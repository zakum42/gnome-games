// This file is part of GNOME Games. License: GPLv3

private class Games.RetroGame : Object, Game {
	private Name _name;
	private string _name_string;
	public string name {
		get {
			try {
				_name_string = _name.get_name ();

				return _name_string;
			}
			catch (Error e) {
				return "";
			}
		}
	}

	public Icon? icon {
		get { return null; }
	}

	private string module_basename;
	private Path path;
	private UniqueIdentifier uid;

	public RetroGame (string module_basename, Name name, Path path, UniqueIdentifier uid) {
		this._name = name;
		this.module_basename = module_basename;
		this.path = path;
		this.uid = uid;
	}

	public Runner get_runner () throws RunError {
		string path_value;
		try {
			path_value = this.path.get_path ();
		}
		catch (Error e) {
			throw new RunError.COULDNT_GET_PATH (@"Couldn't get path: $(e.message)");
		}

		string uid_value;
		try {
			uid_value = this.uid.get_uid ();
		}
		catch (Error e) {
			throw new RunError.COULDNT_GET_UID (@"Couldn't get UID: $(e.message)");
		}

		return new RetroRunner (module_basename, path_value, uid_value);
	}
}
