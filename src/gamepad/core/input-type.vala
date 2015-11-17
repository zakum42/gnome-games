// This file is part of GNOME Games. License: GPLv3

private enum Games.InputType {
	AXIS,
	BUTTON,
	KEY;

	public static InputType? parse_string (string value) {
		var tmp = value.down ();

		switch (tmp) {
		case "axis":
			return InputType.AXIS;
		case "button":
			return InputType.BUTTON;
		case "key":
			return InputType.KEY;
		default:
			return null;
		}
	}

	public static uint length () {
		return InputType.KEY + 1;
	}
}
