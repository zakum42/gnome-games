// This file is part of GNOME Games. License: GPLv3

private class Games.DreamcastTrackerQuery : MimeTypeTrackerQuery {
	private const string MODULE_BASENAME = "libretro-dreamcast.so";

	public override string get_mime_type () {
		return "application/x-dc-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new DreamcastHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "dc", "iso" });
		var path = new UriPath (uri);
		var uid = new DreamcastUID (header);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
