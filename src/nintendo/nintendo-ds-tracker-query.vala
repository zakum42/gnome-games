// This file is part of GNOME Games. License: GPLv3

private class Games.NintendoDsTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "nintendo-ds";
	private const string MODULE_BASENAME = "libretro-nintendo-ds.so";

	public override string get_mime_type () {
		return "application/x-nintendo-ds-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "nds" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
