// This file is part of GNOME Games. License: GPLv3

private class Games.Nintendo64TrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "nintendo-64";
	private const string MODULE_BASENAME = "libretro-nintendo-64.so";

	public override string get_mime_type () {
		return "application/x-n64-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "n64" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
