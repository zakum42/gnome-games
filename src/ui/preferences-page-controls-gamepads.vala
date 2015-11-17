// This file is part of GNOME Games. License: GPLv3

[GtkTemplate (ui = "/org/gnome/Games/ui/preferences-page-controls-gamepads.ui")]
private class Games.PreferencesPageControlsGamepads: Gtk.Stack {
	public signal void add_keyboard_clicked ();
	public signal void back_clicked ();
	public signal void cancel_clicked ();

	[GtkChild]
	private Gtk.Button back_button;

	[GtkCallback]
	private void on_add_keyboard_clicked () {
		add_keyboard_clicked ();
	}

	[GtkCallback]
	private void on_back_clicked () {
		back_clicked ();
	}

	[GtkCallback]
	private void on_cancel_clicked () {
		cancel_clicked ();
	}
}
