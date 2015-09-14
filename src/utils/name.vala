// This file is part of GNOME Games. License: GPLv3

private interface Games.Name: Object {
	public abstract string get_name () throws Error;
}

private class Games.UriName: Object, Name {
	private string uri;
	private string[] extensions;

	public UriName (string uri, string[] extensions) {
		this.uri = uri;
		this.extensions = extensions;
	}

	public string get_name () throws Error {
		var file = File.new_for_uri (uri);
		var name = file.get_basename ();

		foreach (var ext in extensions) {
			var regex = new Regex ("^(.*?)\\." + ext + "$", RegexCompileFlags.CASELESS);
			MatchInfo match_info;
			if (regex.match (name, RegexMatchFlags.ANCHORED, out match_info)) {
				name = match_info.fetch (1);

				break;
			}
			name = regex.replace (name, name.length, 0, "");
		}
		name = name.split ("(")[0];
		name = name.strip ();

		return name;
	}
}
