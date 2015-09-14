// This file is part of GNOME Games. License: GPLv3

private class Games.MegaDriveTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "mega-drive";
	private const string MODULE_BASENAME = "libretro-mega-drive.so";

	public override string get_mime_type () {
		return "application/x-genesis-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new MegaDriveHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "gen", "md", "32x", "mdx", "bin" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
