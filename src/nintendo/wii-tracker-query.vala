// This file is part of GNOME Games. License: GPLv3

private class Games.WiiTrackerQuery : MimeTypeTrackerQuery {
	private const string MODULE_BASENAME = "libretro-wii.so";

	public override string get_mime_type () {
		return "application/x-wii-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new WiiHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "wii", "iso" });
		var path = new UriPath (uri);
		var uid = new WiiUID (header);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
