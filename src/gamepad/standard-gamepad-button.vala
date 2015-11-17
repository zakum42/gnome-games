// This file is part of GNOME Games. License: GPLv3

private enum Games.StandardGamepadButton {
	A,
	B,
	X,
	Y,
	SHOULDER_L,
	SHOULDER_R,
	TRIGGER_L,
	TRIGGER_R,
	SELECT,
	START,
	STICK_L,
	STICK_R,
	DPAD_UP,
	DPAD_DOWN,
	DPAD_LEFT,
	DPAD_RIGHT,
	HOME;

	public static uint length () {
		return StandardGamepadButton.HOME + 1;
	}
}
