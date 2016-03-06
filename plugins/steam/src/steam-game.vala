// This file is part of GNOME Games. License: GPLv3

private class Games.SteamGame : Object, Game {
	private static Icon? steam_icon;

	private string _name;
	public string name {
		get { return _name; }
	}

	private Icon? _icon;
	public Icon? icon {
		get { return _icon != null ? _icon : steam_icon; }
	}

	private string game_id;

	static construct {
		try {
			steam_icon = Icon.new_for_string ("steam");
		}
		catch (Error e) {
			warning ("%s\n", e.message);
		}
	}

	public SteamGame (string uri) throws Error {
		var appmanifest = new SteamAppmanifest (uri);

		game_id = appmanifest.appid;
		_name = appmanifest.name;

		try {
			var icon_name = "steam_icon_" + game_id;
			if (check_icon_exists (icon_name))
				_icon = Icon.new_for_string (icon_name);
		}
		catch (Error e) {
			warning ("%s\n", e.message);
		}
	}

	public Runner get_runner () throws Error {
		return new SteamRunner (game_id);
	}

	private bool check_icon_exists (string icon_name) {
		var theme = Gtk.IconTheme.get_default ();

		return theme.has_icon (icon_name);
	}
}

errordomain Games.SteamGameError {
	NO_APPID,
	NO_NAME,
}
