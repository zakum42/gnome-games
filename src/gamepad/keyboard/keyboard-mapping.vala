// This file is part of GNOME Games. License: GPLv3

private class Games.KeyboardMapping: GamepadMapping {
//	construct {
//		add({ InputType.KEY, InputType.BUTTON, 39, 0 }); // QWERTY S
//		add({ InputType.KEY, InputType.BUTTON, 40, 1 }); // QWERTY D
//		add({ InputType.KEY, InputType.BUTTON, 38, 2 }); // QWERTY A
//		add({ InputType.KEY, InputType.BUTTON, 25, 3 }); // QWERTY W
//		add({ InputType.KEY, InputType.BUTTON, 24, 4 }); // QWERTY Q
//		add({ InputType.KEY, InputType.BUTTON, 26, 5 }); // QWERTY E
//		add({ InputType.KEY, InputType.BUTTON, 10, 6 }); // QWERTY 1
//		add({ InputType.KEY, InputType.BUTTON, 12, 7 }); // QWERTY 3
//		add({ InputType.KEY, InputType.BUTTON, 22, 8 }); // Backspace
//		add({ InputType.KEY, InputType.BUTTON, 36, 9 }); // Enter
//		add({ InputType.KEY, InputType.BUTTON, 52, 10 }); // QWERTY Z
//		add({ InputType.KEY, InputType.BUTTON, 54, 11 }); // QWERTY C
//		add({ InputType.KEY, InputType.BUTTON, 111, 12 }); // Up arrow
//		add({ InputType.KEY, InputType.BUTTON, 116, 13 }); // Down arrow
//		add({ InputType.KEY, InputType.BUTTON, 113, 14 }); // Left arrow
//		add({ InputType.KEY, InputType.BUTTON, 114, 15 }); // Right arrow
//		add({ InputType.KEY, InputType.BUTTON, 110, 16 }); // Home
//	}

	public void map_event (Gdk.EventKey event, bool pressed, Func<GamepadEvent> func) {
		foreach_source (InputType.KEY, event.hardware_keycode, (input_mapping) => {
			var mapped_event = new GamepadEvent ();
			switch (input_mapping.dst_type) {
//			case InputType.AXIS:
//				var mapped_axis_event = new GamepadAxisEvent ();
//				mapped_axis_event.time = event.time;
//				mapped_axis_event.axis = input_mapping.dst_index;
//				mapped_axis_event.value = input_mapping.filter.apply (event.value);

//				mapped_event.axis_event = mapped_axis_event;
//				break;
			case InputType.BUTTON:
				var mapped_button_event = new GamepadButtonEvent ();
				mapped_button_event.time = event.time;
				mapped_button_event.button = input_mapping.dst_index;
				mapped_button_event.value.value = pressed ? 1.0 : 0.0;
				mapped_button_event.value.pressed = pressed;

				mapped_event.button_event = mapped_button_event;
				break;
			}

			func (mapped_event);
		});
	}
}
