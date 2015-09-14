// This file is part of GNOME Games. License: GPLv3

private class Games.AmigaTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "amiga";
	private const string MODULE_BASENAME = "libretro-amiga.so";

	public override string get_mime_type () {
		return "application/x-amiga-disk-file";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "adf" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
