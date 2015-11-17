// This file is part of GNOME Games. License: GPLv3

private class Games.KeyboardGamepad: Object, Gamepad {
	public string id {
		get {
			return "";
		}
	}

	private long _index;
	public long index {
		get { return _index; }
	}

	private bool _connected;
	public bool connected {
		get { return _connected; }
	}

	private time_t _timestamp;
	public time_t timestamp {
		get { return _timestamp; }
	}

	private GamepadMappingType _mapping_type;
	public GamepadMappingType mapping_type {
		get { return _mapping_type; }
	}

	private double[] _axes;
	public double[] axes {
		get { return _axes; }
	}

	private GamepadButton[] _buttons;
	public GamepadButton[] buttons {
		get { return _buttons; }
	}



//	private static MappingDoc mapping_doc;

	public KeyboardMapping mapping { get; set; }

	public KeyboardGamepad (KeyboardDevice keyboard) {
		keyboard.key_event.connect (on_key_event);

		mapping = new KeyboardMapping ();

		_connected = true;
	}

//	construct {
//		if (mapping_doc == null)
//			mapping_doc = new MappingDoc.from_resource ("gamepads/keyboard.gamepads.xml");
//	}

//	private bool mapping_initiated = false;
//	private void init_mapping () {
//		if (mapping_initiated)
//			return;

//		var mapping_node = mapping_doc.get_mapping_for_gamepad_id ("Virtual gamepad");
//		mapping_node.foreach_input_mapping ((input_mapping) => {
//			mapping.add (input_mapping);
//		});

//		mapping_initiated = true;
//	}

	private void on_key_event (Gdk.EventKey event, bool pressed) {
//		init_mapping ();
		mapping.map_event (event, pressed, (gamepad_event) => {
			if (gamepad_event == null)
				return;

			if (gamepad_event.axis_event != null)
				gamepad_axis_event (gamepad_event.axis_event);

			if (gamepad_event.button_event != null)
				gamepad_button_event (gamepad_event.button_event);
		});
	}
}
