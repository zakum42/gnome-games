// This file is part of GNOME Games. License: GPLv3

public class Games.GenericUid : Object, Uid {
	private string uid;

	public GenericUid (string uid) {
		this.uid = uid;
	}

	public string get_uid () throws Error {
		return uid;
	}
}
