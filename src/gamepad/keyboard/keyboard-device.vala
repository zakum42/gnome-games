// This file is part of GNOME Games. License: GPLv3

private interface Games.KeyboardDevice: Object {
	public signal void key_event (Gdk.EventKey event, bool pressed);
}
