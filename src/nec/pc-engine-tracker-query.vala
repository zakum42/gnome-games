// This file is part of GNOME Games. License: GPLv3

private class Games.PcEngineTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "pc-engine";
	private const string MODULE_BASENAME = "libretro-pc-engine.so";

	public override string get_mime_type () {
		return "application/x-pc-engine-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "pce" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
