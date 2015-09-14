// This file is part of GNOME Games. License: GPLv3

private class Games.GameBoyAdvanceTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "game-boy-advance";
	private const string MODULE_BASENAME = "libretro-game-boy-advance.so";

	public override string get_mime_type () {
		return "application/x-gba-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "gba" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
