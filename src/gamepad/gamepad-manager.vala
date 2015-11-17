// This file is part of GNOME Games. License: GPLv3

private class Games.GamepadManager: Object {
	private KeyboardSource keyboard_source;
	private LinuxGamepadSource linux_gamepad_source;

	public GamepadManager (KeyboardDevice keyboard) {
		keyboard_source = new KeyboardSource (keyboard);
		linux_gamepad_source = new LinuxGamepadSource ();
	}

	public void @foreach (Func<Gamepad> func) {
		keyboard_source.foreach (func);
		linux_gamepad_source.foreach (func);
	}
}
