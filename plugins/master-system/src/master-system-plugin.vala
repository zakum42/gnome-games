// This file is part of GNOME Games. License: GPLv3

private class Games.MasterSystemPlugin : Object, Plugin {
	private const string MASTER_SYSTEM_PREFIX = "master-system";
	private const string MASTER_SYSTEM_MIME_TYPE = "application/x-sms-rom";

	private const string GAME_GEAR_PREFIX = "game-gear";
	private const string GAME_GEAR_MIME_TYPE = "application/x-gamegear-rom";

	private const string SG_1000_PREFIX = "sg-1000";
	private const string SG_1000_MIME_TYPE = "application/x-sg1000-rom";

	private const string MODULE_BASENAME = "libretro-master-system.so";
	private const bool SUPPORTS_SNAPSHOTTING = true;

	public GameSource get_game_source () throws Error {
		var game_uri_adapter = new GenericSyncGameUriAdapter (game_for_uri);
		var sg_1000_game_uri_adapter = new GenericSyncGameUriAdapter (sg_1000_game_for_uri);
		var factory = new GenericUriGameFactory (game_uri_adapter);
		var sg_1000_factory = new GenericUriGameFactory (sg_1000_game_uri_adapter);
		var master_system_query = new MimeTypeTrackerQuery (MASTER_SYSTEM_MIME_TYPE, factory);
		var game_gear_query = new MimeTypeTrackerQuery (GAME_GEAR_MIME_TYPE, factory);
		var sg_1000_query = new MimeTypeTrackerQuery (GAME_GEAR_MIME_TYPE, sg_1000_factory);
		var connection = Tracker.Sparql.Connection.@get ();
		var source = new TrackerGameSource (connection);
		source.add_query (master_system_query);
		source.add_query (game_gear_query);
		source.add_query (sg_1000_query);

		return source;
	}

	private static Game game_for_uri (string uri) throws Error {
		var file = File.new_for_uri (uri);
		var header = new MasterSystemHeader (file);
		header.check_validity ();

		string prefix;
		string mime_type;
		if (header.is_master_system ()) {
			prefix = MASTER_SYSTEM_PREFIX;
			mime_type = MASTER_SYSTEM_MIME_TYPE;
		}
		else if (header.is_game_gear ()) {
			prefix = GAME_GEAR_PREFIX;
			mime_type = GAME_GEAR_MIME_TYPE;
		}
		else
			assert_not_reached ();

		var uid = new FingerprintUid (uri, prefix);
		var title = new FilenameTitle (uri);
		var icon = new DummyIcon ();
		var media = new GriloMedia (title, mime_type);
		var cover = new CompositeCover ({
			new LocalCover (uri),
			new GriloCover (media, uid)});
		var runner = new RetroRunner.with_mime_types (uri, uid, { mime_type }, MODULE_BASENAME, SUPPORTS_SNAPSHOTTING);

		return new GenericGame (title, icon, cover, runner);
	}

	private static Game sg_1000_game_for_uri (string uri) throws Error {
		var uid = new FingerprintUid (uri, SG_1000_PREFIX);
		var title = new FilenameTitle (uri);
		var icon = new DummyIcon ();
		var media = new GriloMedia (title, SG_1000_MIME_TYPE);
		var cover = new CompositeCover ({
			new LocalCover (uri),
			new GriloCover (media, uid)});
		var runner = new RetroRunner.with_mime_types (uri, uid, { SG_1000_MIME_TYPE }, MODULE_BASENAME, SUPPORTS_SNAPSHOTTING);

		return new GenericGame (title, icon, cover, runner);
	}
}

[ModuleInit]
public Type register_games_plugin (TypeModule module) {
	return typeof(Games.MasterSystemPlugin);
}
