// This file is part of GNOME Games. License: GPLv3

[GtkTemplate (ui = "/org/gnome/Games/ui/app-window.ui")]
private class Games.AppWindow : Gtk.ApplicationWindow {

    Gtk.ListStore games_list_store;

    [GtkChild]
    Gtk.IconView games_icon_view;

    public void load_games (GameSource game_source) {
        this.games_list_store = new Gtk.ListStore (2,
                                                   typeof (string),
                                                   typeof (Gdk.Pixbuf));

        games_icon_view.set_model (games_list_store);
        games_icon_view.set_text_column (0);
        games_icon_view.set_pixbuf_column (1);

        var icon_theme = Gtk.IconTheme.get_default ();

        game_source.each_game ((game) => {
	    var icon_info = icon_theme.lookup_by_gicon (game.icon, 64, Gtk.IconLookupFlags.FORCE_SIZE);
	    var pixbuf = icon_info.load_icon ();

            Gtk.TreeIter iter;
            games_list_store.append (out iter);
            games_list_store.set (iter, 0, game.name,
                                        1, pixbuf);
        });
    }
}

