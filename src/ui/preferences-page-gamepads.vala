// This file is part of GNOME Games. License: GPLv3

[GtkTemplate (ui = "/org/gnome/Games/ui/preferences-page-gamepads.ui")]
private class Games.PreferencesPageGamepads: Gtk.Bin, PreferencesPage {
	private const StandardGamepadButton[] STANDARD_GAMEPAD_BUTTONS = {
		StandardGamepadButton.DPAD_UP,
		StandardGamepadButton.DPAD_DOWN,
		StandardGamepadButton.DPAD_LEFT,
		StandardGamepadButton.DPAD_RIGHT,
		StandardGamepadButton.A,
		StandardGamepadButton.B,
		StandardGamepadButton.X,
		StandardGamepadButton.Y,
		StandardGamepadButton.SHOULDER_L,
		StandardGamepadButton.SHOULDER_R,
		StandardGamepadButton.TRIGGER_L,
		StandardGamepadButton.TRIGGER_R,
		StandardGamepadButton.START,
		StandardGamepadButton.SELECT,
		StandardGamepadButton.HOME,
		StandardGamepadButton.STICK_L,
		StandardGamepadButton.STICK_R,
	};

	public string name {
		get { return "gamepads"; }
	}

	public string title {
		get { return _("Gamepads"); }
	}

	private PreferencesPageControlsGamepads _controls;
	public Gtk.Widget controls {
		get { return _controls; }
	}

	[GtkChild]
	private Gtk.Stack stack;
	[GtkChild]
	private Gtk.ScrolledWindow gamepads;
	[GtkChild]
	private Gtk.ListBox list_box;
	[GtkChild]
	private InputBox testing_box;
	[GtkChild]
	private InputBox mapping_box;
	[GtkChild]
	private StandardGamepadView testing_view;
	[GtkChild]
	private StandardGamepadView mapping_view;

	private GenericSet<uint16?> previously_pressed_keys;
	private GenericSet<uint16?> recently_pressed_keys;
	private bool new_mapping;
	private KeyboardMapping current_keyboard_mapping;
	private int current_mapping_index;

	construct {
		var keyboard_source = new KeyboardSource (testing_box);
		keyboard_source.foreach (add_gamepad);

		_controls = new PreferencesPageControlsGamepads ();
		_controls.add_keyboard_clicked.connect (on_add_keyboard_clicked);
		_controls.back_clicked.connect (on_back_clicked);
		_controls.cancel_clicked.connect (on_cancel_clicked);
		mapping_box.key_event.connect (on_mapping_key_event);

		stack.bind_property ("visible-child-name", _controls,
		                     "visible-child-name", BindingFlags.SYNC_CREATE);
	}

	[GtkCallback]
	private void on_row_activated (Gtk.ListBoxRow row) {
		var item = row.get_child () as PreferencesPageGamepadsItem;
		if (item == null)
			return;

		var gamepad = item.gamepad;
		if (gamepad == null)
			return;

		testing_view.gamepad = gamepad;

		set_visible_page (testing_box);
	}

	private void on_back_clicked () {
		set_visible_page (gamepads);
	}

	private void on_cancel_clicked () {
		previously_pressed_keys = null;
		recently_pressed_keys = null;
		current_mapping_index = -1;
		if (new_mapping)
			set_visible_page (gamepads);
		else
			set_visible_page (testing_box);
	}

	private void add_gamepad (Gamepad gamepad) {
		var item = new PreferencesPageGamepadsItem (gamepad);
		var row = new Gtk.ListBoxRow ();
		row.add (item);
		list_box.add (row);

		item.show ();
		row.show ();
	}

	/* Keyboard mapping */

	private void on_add_keyboard_clicked () {
		new_mapping = true;
		set_visible_page (mapping_box);
		map_keyboard ();
	}

	private void on_mapping_key_event (Gdk.EventKey event, bool pressed) {
		if (current_mapping_index < 0)
			return;

		if (previously_pressed_keys == null)
			return;

		var previously_pressed = previously_pressed_keys.contains (event.hardware_keycode);
		var recently_pressed = recently_pressed_keys.contains (event.hardware_keycode);

		if (!recently_pressed) {
			if (previously_pressed) {
				if (!pressed)
					previously_pressed_keys.remove (event.hardware_keycode);

				return;
			}

			if (pressed) {
				previously_pressed_keys.add (event.hardware_keycode);
				recently_pressed_keys.add (event.hardware_keycode);

				return;
			}

			return;
		}

		if (pressed)
			return;

		previously_pressed_keys.remove (event.hardware_keycode);

		var key = event.hardware_keycode;
		var button = STANDARD_GAMEPAD_BUTTONS[current_mapping_index];
		InputMapping input_mapping = {
			InputType.KEY, InputType.BUTTON,
			key, button
		};
		current_keyboard_mapping.add (input_mapping);

		current_keyboard_mapping.id += "%04x".printf (key);

		current_mapping_index++;
		if (current_mapping_index >= STANDARD_GAMEPAD_BUTTONS.length)
			on_mapping_complete ();
		else
			prompt_current_button ();
	}

	private void map_keyboard () {
		previously_pressed_keys = new GenericSet<uint16?> (int_hash, int_equal);
		current_mapping_index = 0;
		current_keyboard_mapping = new KeyboardMapping ();
		current_keyboard_mapping.id = "";
		mapping_view.reset ();
		prompt_current_button ();
	}

	private void prompt_current_button () {
		recently_pressed_keys = new GenericSet<uint16?> (int_hash, int_equal);

		var button = STANDARD_GAMEPAD_BUTTONS[current_mapping_index];
		mapping_view.reset ();
		mapping_view.highlight_button (button, true);
	}

	private void on_mapping_complete () {
		previously_pressed_keys = null;
		recently_pressed_keys = null;
		current_mapping_index = -1;

		var fingerprint = Checksum.compute_for_string (ChecksumType.MD5, current_keyboard_mapping.id);
		var dir = Application.get_keyboard_mappings_dir ();

		var file = File.new_for_path (dir);
		if (!file.query_exists ())
			file.make_directory_with_parents ();

		var doc = new MappingDoc.from_mapping (current_keyboard_mapping);
		doc.save (@"$dir/$fingerprint.mapping.xml");

		var gamepad = new KeyboardGamepad (testing_box);
		gamepad.mapping = current_keyboard_mapping;
		testing_view.gamepad = gamepad;
		add_gamepad (gamepad);

		set_visible_page (testing_box);
	}

	private void set_visible_page (Gtk.Widget page) {
		if (page == testing_box)
			testing_view.reset ();

		if (page != mapping_box) {
			previously_pressed_keys = null;
			recently_pressed_keys = null;
			current_mapping_index = -1;
		}

		testing_box.keep_focus = page == testing_box;
		mapping_box.keep_focus = page == mapping_box;

		stack.visible_child = page;
		stack.visible_child.grab_focus ();
	}
}
