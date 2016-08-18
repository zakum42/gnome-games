public interface UriGameFactory : Object {
	public abstract bool is_uri_valid (string uri);
	public abstract void add_uri (string uri);
	public abstract async void foreach_game (Games.GameCallback game_callback);
}

public delegate bool Games.UriTest (string uri);
