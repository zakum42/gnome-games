// This file is part of GNOME Games. License: GPLv3

public class Games.TrackerGameSourceMultiDisk : Object, GameSource {
	private const uint HANDLED_GAMES_PER_CYCLE = 5;

	private Tracker.Sparql.Connection connection { private set; get; }
	private TrackerQuery[] queries;

	public TrackerGameSourceMultiDisk (Tracker.Sparql.Connection connection) {
		this.connection = connection;
	}

	construct {
		queries = {};
	}

	public void add_query (TrackerQuery query) {
		queries += query;
	}

	public async void each_game (GameCallback game_callback) {
		for (size_t i = 0 ; i < queries.length ; i++)
			yield each_game_for_query (game_callback, queries[i]);
	}

	public async void each_game_for_query (GameCallback game_callback, TrackerQuery query) {
		var sparql = query.get_query ();
		string[] titles = {};

		Tracker.Sparql.Cursor cursor;
		try {
			cursor = connection.query (sparql);
		}
		catch (Error e) {
			warning ("Error: %s\n", e.message);
			return;
		}

		bool is_cursor_valid = false;
		uint handled_games = 0;

		try {
			is_cursor_valid = cursor.next ();
		}
		catch (Error e) {
			is_cursor_valid = false;
			warning ("Error: %s\n", e.message);
		}
		while (is_cursor_valid) {
			if (query.is_cursor_valid (cursor))
				try {
					// These lines will be removed once the multi-disk support is fully implemented
					var game = query.game_for_cursor (cursor);
					game_callback (game);
					handled_games++;

					// WIP CODE
					var uri = cursor.get_string (0);
					var title = new FilenameTitle (uri).get_raw_title();
					titles += title;

					// Free the execution only once every HANDLED_GAMES_PER_CYCLE
					// games to speed up the execution by avoiding too many context
					// switching.
					if (handled_games >= HANDLED_GAMES_PER_CYCLE) {
						handled_games = 0;

						Idle.add (this.each_game_for_query.callback);
						yield;
					}
				}
				catch (TrackerError.FILE_NOT_FOUND e) {
					debug (e.message);
				}
				catch (Error e) {
					warning ("Error: %s\n", e.message);
				}

			try {
				is_cursor_valid = cursor.next ();
			}
			catch (Error e) {
				is_cursor_valid = false;
				warning ("Error: %s\n", e.message);
				continue;
			}
		}
		// Alternative: use Gee.List and remove games from the list once they've been added
		bool[] game_added = new bool[titles.length];
		for (int i = 0; i < game_added.length; ++i)
			game_added[i] = false;
		for (int i = 0; i < titles.length; ++i) {
			if (!game_added[i]) {
				string t1 = titles[i];
				string[] disk_list = {t1};
				game_added[i] = true;
				for (int j = 0; j < titles.length; ++j) {
					if (!game_added[j]) {
						string t2 = titles[j];
						bool b1 = t1.down().contains("disc")||t1.down().contains("disk")||t1.down().contains("track");
						bool b2 = t2.down().contains("disc")||t2.down().contains("disk")||t2.down().contains("track");
						if (b1 && b2 && (JaroWinklerDistance.distance(t1, t2) >= 0.9))  {
							disk_list += t2;
							game_added[j] = true;
						}
					}
				}
			//Create the game here, once we get all its parts
			foreach(var k in disk_list) stdout.printf(k+"\n");
			//++handled_games;
			}
		}
	}
}
