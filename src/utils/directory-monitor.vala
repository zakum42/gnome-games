// This file is part of GNOME Games. License: GPLv3

private class Games.DirectoryMonitor: Object {
	public signal void file_created (string uri);
	public signal void file_deleted (string uri);

	private File directory;
	private FileMonitor monitor;
	private Regex files_matching;

	public DirectoryMonitor (string directory_path, Regex files_matching) throws IOError {
		this.files_matching = files_matching;

		directory = File.new_for_path (directory_path);
		monitor = directory.monitor_directory (FileMonitorFlags.NONE);
		monitor.changed.connect (on_changed);
	}

	public void @foreach (Func<string> func) {
		try {
			var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);

			FileInfo file_info;
			while ((file_info = enumerator.next_file ()) != null) {
				var filename = file_info.get_name ();
				var file = directory.get_child (filename);
				if (!is_file_valid (file))
					continue;

				var uri = file.get_uri ();
				func (uri);
			}
		}
		catch (Error e) {
			warning (e.message);
		}
	}

	private void on_changed (File file, File? other_file, FileMonitorEvent event_type) {
		if (!is_file_valid (file))
			return;

		switch (event_type) {
			case FileMonitorEvent.CREATED:
				var info = file.query_info ("*", FileQueryInfoFlags.NONE);
				if (info.get_attribute_boolean (FileAttribute.ACCESS_CAN_READ)) {
					var uri = file.get_uri ();
					file_created (uri);
				}
				else
					monitor_can_read (file);
				break;
			case FileMonitorEvent.DELETED:
				var uri = file.get_uri ();
				file_deleted (uri);
				break;
		}
	}

	private void monitor_can_read (File file) {
		var specific_monitor = file.monitor_file (FileMonitorFlags.NONE);

		ulong id = 0;
		id = specific_monitor.changed.connect ((f1, f2, event) => {
			switch (event) {
				case FileMonitorEvent.DELETED:
					specific_monitor.disconnect (id);
					specific_monitor.cancel ();
					return;

				case FileMonitorEvent.ATTRIBUTE_CHANGED:
					var info = file.query_info ("*", FileQueryInfoFlags.NONE);
					if (info.get_attribute_boolean (FileAttribute.ACCESS_CAN_READ)) {
						var uri = file.get_uri ();
						file_created (uri);
						specific_monitor.disconnect (id);
						specific_monitor.cancel ();
					}
					break;
			}
		});
	}

	private bool is_file_valid (File file) {
		var basename = file.get_basename ();

		return files_matching.match (basename);
	}
}
