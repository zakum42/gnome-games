// This file is part of GNOME Games. License: GPLv3

private class Games.SnesTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "snes";
	private const string MODULE_BASENAME = "libretro-snes.so";

	public override string get_mime_type () {
		return "application/vnd.nintendo.snes.rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "sfc" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
