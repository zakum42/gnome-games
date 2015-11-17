// This file is part of GNOME Games. License: GPLv3

private class Games.LinuxGamepadSource: LinuxJoystickMonitor, GamepadSource {
	private HashTable<string, Gamepad> gamepads;

	public LinuxGamepadSource () {
		base ("/dev/input");

		gamepads = new HashTable<string, Gamepad> (str_hash, str_equal);

		joystick_plugged.connect ((number, path) => {
			add_joystick (path);
		});

		joystick_plugged.connect ((number, path) => {
			remove_joystick (path);
		});

		foreach (var joystick_path in get_joysticks ())
			add_joystick (joystick_path);
	}

	public void @foreach (Func<Gamepad> func) {
		foreach (var gamepad in gamepads.get_values ())
			func (gamepad);
	}

	private void add_joystick (string joystick_path) {
		if (gamepads.contains (joystick_path))
			return;

		gamepads[joystick_path] = new LinuxGamepad (joystick_path);
	}

	private void remove_joystick (string joystick_path) {
		if (!gamepads.contains (joystick_path))
			return;

		gamepads.remove (joystick_path);
	}
}
