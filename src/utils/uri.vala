// This file is part of GNOME Games. License: GPLv3

namespace Games.Uri {
	public string for_path (string path) {
		var file = File.new_for_path (path);

		return file.get_uri ();
	}
}
