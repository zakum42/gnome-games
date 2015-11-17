// This file is part of GNOME Games. License: GPLv3

private enum Games.FilterType {
	NONE,
	POSITIVE,
	NEGATIVE;

	public static FilterType? parse_string (string value) {
		var tmp = value.down ();

		switch (tmp) {
		case "none":
			return FilterType.NONE;
		case "positive":
			return FilterType.POSITIVE;
		case "negative":
			return FilterType.NEGATIVE;
		default:
			return null;
		}
	}

	public double apply (double value) {
		switch (this) {
		case FilterType.NONE:
			return value;
		case FilterType.POSITIVE:
			return value < 0.0 ? 0.0 : value;
		case FilterType.NEGATIVE:
			return value > 0.0 ? 0.0 : -value;
		default:
			return value;
		}
	}
}
