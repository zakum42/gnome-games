// This file is part of GNOME Games. License: GPLv3

[GtkTemplate (ui = "/org/gnome/Games/ui/input-box.ui")]
private class Games.InputBox: Gtk.EventBox, KeyboardDevice {
	public bool keep_focus { set; get; }

	[GtkCallback]
	private bool on_key_press_event (Gdk.EventKey event) {
		key_event (event, true);

		return false;
	}

	[GtkCallback]
	private bool on_key_release_event (Gdk.EventKey event) {
		key_event (event, false);

		return false;
	}

	[GtkCallback]
	private bool on_button_press_event (Gdk.EventButton event) {
		grab_focus ();

		return false;
	}

	[GtkCallback]
	private bool on_focus_in_event (Gdk.EventFocus event) {
		has_focus = true;

		return false;
	}

	[GtkCallback]
	private bool on_focus_out_event (Gdk.EventFocus event) {
		if (keep_focus)
			has_focus = true;

		return false;
	}
}
