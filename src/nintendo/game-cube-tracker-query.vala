// This file is part of GNOME Games. License: GPLv3

private class Games.GameCubeTrackerQuery : MimeTypeTrackerQuery {
	private const string MODULE_BASENAME = "libretro-game-cube.so";

	public override string get_mime_type () {
		return "application/x-gamecube-rom";
	}

	public override Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new GameCubeHeader (file);
		header.check_validity ();

		var name = new UriName (uri, { "gc", "iso" });
		var path = new UriPath (uri);
		var uid = new GameCubeUID (header);

		return new RetroGame (MODULE_BASENAME, name, path, uid);
	}
}
