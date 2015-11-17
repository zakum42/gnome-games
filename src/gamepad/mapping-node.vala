// This file is part of GNOME Games. License: GPLv3

private class Games.MappingNode: XmlNode {
	private MappingDoc doc;

	internal MappingNode (MappingDoc doc, Xml.Node* node) {
		base (doc, node);

		this.doc = doc;
	}

	internal MappingNode.for_node (XmlNode node) {
		this (node.doc as MappingDoc, node.node);
	}

	public void foreach_input_mapping (Func<InputMapping?> func) {
		@foreach_child ((dst_input_node) => {
			for_input_mapping (dst_input_node, func);
		});
	}

	public void add_input_mapping (InputMapping? input_mapping) {
		var dst_type = input_mapping.dst_type.to_string ();
		var dst_node = add_child (dst_type);

		var dst_index = input_mapping.dst_index.to_string ();
		dst_node.set_prop ("index", dst_index);

		var src_type = input_mapping.src_type.to_string ();
		var src_node = dst_node.add_child (src_type);

		var src_index = input_mapping.src_index.to_string ();
		src_node.set_prop ("index", src_index);
	}

	private void for_input_mapping (Xml.Node* dst_input_node, Func<InputMapping?> func) {
		var dst_index = get_index_for_input_node (dst_input_node);
		if (dst_index == null)
			return;

		var dst_type = get_type_for_input_node (dst_input_node);
		if (dst_type == null)
			return;

		Xml.Node* src_input_node = dst_input_node->children;
		if (src_input_node == null)
			return;

		var src_index = get_index_for_input_node (src_input_node);
		if (src_index == null)
			return;

		var src_type = get_type_for_input_node (src_input_node);
		if (src_type == null)
			return;

		var filter = get_filter_for_input_node (src_input_node);

		var input_mapping = InputMapping () {
			src_type = src_type,
			dst_type = dst_type,
			src_index = (uint8) src_index,
			dst_index = (uint8) dst_index,
			filter = filter
		};

		func (input_mapping);
	}

	private static int? get_index_for_input_node (Xml.Node* input_node) {
		var index_string = input_node->get_prop ("index");
		if (index_string == null)
			return null;

		return int.parse (index_string);
	}

	private static InputType? get_type_for_input_node (Xml.Node* input_node) {
		return InputType.parse_string (input_node->name);
	}

	private static FilterType get_filter_for_input_node (Xml.Node* input_node) {
		var filter = input_node->get_prop ("filter");

		return FilterType.parse_string (filter) ?? FilterType.NONE;
	}

	private GamepadMappingType get_mapping_type () {
		var mapping_type = get_prop ("type");

		switch (mapping_type) {
		case "standard":
			return GamepadMappingType.STANDARD;
		default:
			return GamepadMappingType.NONE;
		}
	}
}
