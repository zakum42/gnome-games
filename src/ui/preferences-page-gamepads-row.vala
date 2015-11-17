// This file is part of GNOME Games. License: GPLv3

private class Games.PreferencesPageGamepadsItem: Gtk.Label {
	public Gamepad gamepad { private set; get; }

	public PreferencesPageGamepadRowItem (Gamepad gamepad) {
		this.gamepad = gamepad;
	}

	construct {
		visible = true;
		text = "Gamepad";
	}
}
