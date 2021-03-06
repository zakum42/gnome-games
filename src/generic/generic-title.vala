// This file is part of GNOME Games. License: GPLv3

public class Games.GenericTitle : Object, Title {
	private string title;

	public GenericTitle (string title) {
		this.title = title;
	}

	public string get_title () throws Error {
		return title;
	}
}
