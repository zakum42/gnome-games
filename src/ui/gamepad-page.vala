// This file is part of GNOME Games. License: GPLv3

private class Games.GamepadPage: Gtk.Bin {
	private StandardGamepadView view;
	private KeyboardGamepad gamepad;

	construct {
		visible = true;

		view = new StandardGamepadView ();

		var keyboard = new InputBox ();
		keyboard.add (view);

		add (keyboard);

		gamepad = new KeyboardGamepad (keyboard);
		gamepad.gamepad_button_event.connect (on_button_event);

		show_all ();
	}

	private void on_button_event (GamepadButtonEvent event) {
		view.highlight_button ((StandardGamepadButton) event.button, event.value.pressed);
	}
}
