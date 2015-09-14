// This file is part of GNOME Games. License: GPLv3

private class Games.SegaSaturnTrackerQuery : MimeTypeTrackerQuery {
	private const string MODULE_BASENAME = "libretro-saturn.so";

	public override string get_mime_type () {
		return "application/x-saturn-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new SegaSaturnHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "cue", "bin", "iso" });
		var path = new UriPath (uri);
		var uid = new SegaSaturnUID (header);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
