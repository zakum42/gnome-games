// This file is part of GNOME Games. License: GPLv3

private class Games.NesTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "nes";
	private const string MODULE_BASENAME = "libretro-nes.so";

	public override string get_mime_type () {
		return "application/x-nes-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "nes" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
