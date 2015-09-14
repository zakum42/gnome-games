// This file is part of GNOME Games. License: GPLv3

private class Games.DoomTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "doom";
	private const string MODULE_BASENAME = "libretro-doom.so";

	public override string get_mime_type () {
		return "application/x-doom-wad";
	}

	public override Game game_for_uri (string uri) throws Error {
		var name = new UriName (uri, { "wad" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
