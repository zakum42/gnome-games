// This file is part of GNOME Games. License: GPLv3

private class Games.KeyboardWidget: Gtk.EventBox, KeyboardDevice {
	construct {
		set_can_focus (true);

		focus_in_event.connect (on_focus_in_event);
		focus_out_event.connect (on_focus_out_event);

		button_press_event.connect (on_button_press_event);

		key_press_event.connect (on_key_press_event);
		key_release_event.connect (on_key_release_event);
	}

	private bool on_key_press_event (Gdk.EventKey event) {
		key_event (event, true);

		return false;
	}

	private bool on_key_release_event (Gdk.EventKey event) {
		key_event (event, false);

		return false;
	}

	private bool on_button_press_event (Gdk.EventButton event) {
		grab_focus ();

		return false;
	}

	private bool on_focus_in_event (Gdk.EventFocus event) {
		has_focus = true;

		return false;
	}

	private bool on_focus_out_event (Gdk.EventFocus event) {
		has_focus = false;

		return false;
	}
}
