// This file is part of GNOME Games. License: GPLv3

private interface Games.Path: Object {
	public abstract string get_path () throws Error;
}

private class Games.UriPath: Object, Path {
	private string uri;

	public UriPath (string uri) {
		this.uri = uri;
	}

	public string get_path () throws Error {
		var file = File.new_for_uri (uri);

		return file.get_path ();
	}
}

private class Games.CuePath: Object, Path {
	private string uri;

	public UriPath (string uri) {
		this.uri = uri;
	}

	public string get_path () throws Error {
		var file = File.new_for_uri (uri);
		var cue = get_associated_cue_sheet (file);

		return cue ?? file.get_path ();
	}

	private string? get_associated_cue_sheet (File file) throws Error {
		var directory = file.get_parent ();
		var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);

		FileInfo file_info;
		while ((file_info = enumerator.next_file ()) != null) {
			var name = file_info.get_name ();
			var child = directory.resolve_relative_path (name);
			var child_info = child.query_info ("*", FileQueryInfoFlags.NONE);
			var type = child_info.get_content_type ();

			if (type == "application/x-cue" && cue_contains_file (child, file))
				return child.get_path ();
		}

		return null;
	}
}
