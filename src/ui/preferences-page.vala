// This file is part of GNOME Games. License: GPLv3

private interface Games.PreferencesPage: Gtk.Widget {
	public abstract string name { get; }

	public abstract string title { get; }
	public abstract Gtk.Widget controls { get; }
}
