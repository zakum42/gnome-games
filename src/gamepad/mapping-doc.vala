// This file is part of GNOME Games. License: GPLv3

private class Games.MappingDoc: XmlDoc {
	public MappingDoc () {
		base ("1.0");

		Xml.Node* root = new Xml.Node (null, "gamepads");
		doc->set_root_element (root);
	}

	public MappingDoc.from_file (string filename) throws XmlError {
		base.from_file (filename);
	}

	public MappingDoc.from_resource (string resource) throws Error {
		base.from_resource (resource);

		// TODO Check if the document is well formed.
	}

	public MappingDoc.from_mapping (GamepadMapping mapping) throws Error {
		this ();

		var gamepads_node = lookup_node ("/gamepads");
		var gamepad_node = gamepads_node.add_child ("gamepad");
		var mapping_xml_node = gamepad_node.add_child ("mapping");
		var mapping_node = new MappingNode.for_node (mapping_xml_node);

		gamepad_node.set_prop ("id", mapping.id);

		mapping.foreach ((input_mapping) => {
			mapping_node.add_input_mapping (input_mapping);
		});
	}

	public void foreach_mapping_node (Func<MappingNode> func) {
		@foreach ("/gamepads/gamepad/mapping", null, (node) => {
			var mapping_node = new MappingNode (this, node);
			func (mapping_node);
		});
	}

	public MappingNode? get_mapping_for_gamepad_id (string id) {
		var expr = "/gamepads/gamepad[@id = \"" + id + "\"]/mapping";

		Xml.Node* node = lookup_node (expr);
		if (node == null)
			return null;

		return new MappingNode (this, node);
	}
}
