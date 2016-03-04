// This file is part of GNOME Games. License: GPLv3

private class Games.SteamGameSource : Object, GameSource {
	private delegate void AppmanifestCallback (string appmanifest);

	// From the home directory.
	private const string REGISTRY_PATH = "/.steam/registry.vdf";
	// From an install directory.
	private const string[] STEAMAPPS_DIRS = { "/SteamApps", "/steamapps" };
	// From the default SteamApp directory.
	private const string LIBRARY_DIRS_REG = "/libraryfolders.vdf";

	private const string[] INSTALL_PATH_REGISTRY_PATH =
		{ "Registry", "HKLM", "Software", "Valve", "Steam", "InstallPath" };

	private static Regex appmanifest_regex;

	private string[] libraries;

	public SteamGameSource () throws Error {
		if (appmanifest_regex == null)
			appmanifest_regex = /appmanifest_\d+\.acf/;

		// Steam's installation path can be found in its registry.
		var registry_path = Environment.get_home_dir () + REGISTRY_PATH;
		var registry = new SteamRegistry (Uri.for_path (registry_path));
		var install_path = registry.get_data (INSTALL_PATH_REGISTRY_PATH);

		libraries = { install_path };

		// `/LibraryFolders/$NUMBER` entries in the libraryfolders.vdf registry
		// file are library directories.
		foreach (var steamapps_dir in STEAMAPPS_DIRS) {
			var install_steamapps_dir = install_path + steamapps_dir;
			var file = File.new_for_path (install_steamapps_dir);
			if (!file.query_exists ())
				continue;

			var library_reg_path = install_steamapps_dir + LIBRARY_DIRS_REG;
			var library_reg = new SteamRegistry (Uri.for_path (library_reg_path));
			foreach (var child in library_reg.get_children ({ "LibraryFolders" }))
				if (/^\d+$/.match (child))
					libraries += library_reg.get_data ({ "LibraryFolders", child });
		}
	}

	public bool is_uri_valid (string uri) {
		try {
			new SteamAppmanifest (uri);
		}
		catch (Error e) {
			return false;
		}

		return true;
	}

	public async void each_game (GameCallback game_callback) {
		yield each_appmanifest ((appmanifest) => {
			for_appmanifest_game (appmanifest, game_callback);
		});
	}

	private async void each_appmanifest (AppmanifestCallback appmanifest_callback) {
		foreach (var library in libraries)
			foreach (var steamapps_dir in STEAMAPPS_DIRS)
				yield each_appmanifest_in_steamapps_dir (library + steamapps_dir, appmanifest_callback);
	}

	private async void each_appmanifest_in_steamapps_dir (string directory, AppmanifestCallback appmanifest_callback) {
		try {
			var file = File.new_for_path (directory);

			var enumerator = yield file.enumerate_children_async (FileAttribute.STANDARD_NAME, 0);

			FileInfo info;
			while ((info = enumerator.next_file ()) != null)
				yield appmanifest_for_file_info (directory, info, appmanifest_callback);
		}
		catch (Error e) {
		}
	}

	private async void appmanifest_for_file_info (string directory, FileInfo info, AppmanifestCallback appmanifest_callback) {
		var name = info.get_name ();
		if (appmanifest_regex.match (name)) {
			appmanifest_callback (Uri.for_path (@"$directory/$name"));

			Idle.add (this.appmanifest_for_file_info.callback);
			yield;
		}
	}

	private void for_appmanifest_game (string appmanifest, GameCallback game_callback) {
		try {
			var game = new SteamGame (appmanifest);
			game_callback (game);
		}
		catch (Error e) {
			warning ("%s\n", e.message);
		}
	}
}
