// This file is part of GNOME Games. License: GPLv3

private class Games.GameBoyTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "game-boy";
	private const string MODULE_BASENAME = "libretro-game-boy.so";

	public override string get_mime_type () {
		return "application/x-gameboy-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new GameBoyHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "gb", "gbc" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
