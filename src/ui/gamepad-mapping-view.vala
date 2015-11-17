// This file is part of GNOME Games. License: GPLv3

[GtkTemplate (ui = "/org/gnome/Games/ui/gamepad-mapping-view.ui")]
private class Games.GamepadMappingView: Gtk.Bin {
	[GtkChild]
	private InputBox input_box;
	[GtkChild]
	private StandardGamepadView gamepad_view;

	private KeyboardGamepad gamepad;

	construct {
		gamepad = new KeyboardGamepad (input_box);
		gamepad.gamepad_button_event.connect (on_button_event);
	}

	private void on_button_event (GamepadButtonEvent event) {
		var button = (StandardGamepadButton) event.button;
		gamepad_view.highlight_button (button, event.value.pressed);
	}
}
