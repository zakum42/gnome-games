// This file is part of GNOME Games. License: GPLv3

private class Games.SteamAppmanifest : Object {
	private static Regex appmanifest_regex;

	public string appid { private set; get; }

	public string name { private set; get; }

	private string uri;
	private SteamRegistry registry;

	public SteamAppmanifest (string uri) throws Error {
		this.uri = uri;
		registry = new SteamRegistry (uri);

		init_appid ();
		init_name ();
	}

	private void init_appid () throws Error {
		var appid = registry.get_data ({"AppState", "appid"});
		/* The appid sometimes is identified by appID
		 * see issue https://github.com/Kekun/gnome-games/issues/169 */
		if (appid == null)
			appid = registry.get_data ({"AppState", "appID"});

		if (appid == null)
			throw new SteamGameError.NO_APPID (_("Couldn't get appid from manifest '%s'"), uri);

		this.appid = appid;
	}

	private void init_name () throws Error {
		var name = registry.get_data ({"AppState", "name"});
		if (name == null)
			throw new SteamGameError.NO_NAME (_("Couldn't get name from manifest '%s'"), uri);

		this.name = name;
	}
}
