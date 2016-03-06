// This file is part of GNOME Games. License: GPLv3

public interface Games.GameSource : Object {
	public abstract bool is_uri_valid (string uri);
	public abstract Game game_for_uri (string uri) throws Error;
	public abstract async void each_game (GameCallback callback);
}

public delegate void Games.GameCallback (Game game);
