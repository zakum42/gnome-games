// This file is part of GNOME Games. License: GPLv3

private class Games.XmlNode: Object {
	protected XmlDoc doc;
	protected Xml.Node* node;

	public XmlNode (XmlDoc doc, Xml.Node* node) {
		this.doc = doc;
		this.node = node;
	}

	public XmlNode add_child (string name) {
		Xml.Node* child = node->new_child (null, name, null);

		return new XmlNode (doc, child);
	}

	public XmlNode lookup_node (string xpath) {
		return doc.lookup_node (xpath, node);
	}

	public XmlNode get_parent () {
		return new XmlNode (doc, node->parent);
	}

	public string? get_content () {
		return node->get_content ();
	}

	public string? get_prop (string prop) {
		return node->get_prop (prop);
	}

	public void set_prop (string prop, string value) {
		if (node->has_prop (prop) != null)
			node->set_prop (prop, value);
		else
			node->new_prop (prop, value);
	}

	public void @foreach (string xpath, Func<unowned Xml.Node*> func) {
		doc.foreach (xpath, node, func);
	}

	public void foreach_child (Func<unowned Xml.Node*> func) {
		for (Xml.Node* child = node->children; child != null; child = child->next)
			func (child);
	}
}
