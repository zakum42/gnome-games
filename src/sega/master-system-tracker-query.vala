// This file is part of GNOME Games. License: GPLv3

private class Games.MasterSystemTrackerQuery : MimeTypeTrackerQuery {
	private const string FINGERPRINT_PREFIX = "master-system";
	private const string MODULE_BASENAME = "libretro-master-system.so";

	public override string get_mime_type () {
		return "application/x-sms-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new MasterSystemHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "sms", "gg" });
		var path = new UriPath (uri);
		var uid = new FingerprintUID (uri, FINGERPRINT_PREFIX);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
