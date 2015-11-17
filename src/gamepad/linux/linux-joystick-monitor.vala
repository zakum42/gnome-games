// This file is part of GNOME Games. License: GPLv3

private class Games.LinuxJoystickMonitor: Object {
	public string joystick_directory { get; private set; }

	private File directory;
	private FileMonitor monitor;

	public signal void joystick_plugged (uint number, string file_name);
	public signal void joystick_unplugged (uint number, string file_name);

	private static Regex name_regex = /js(\d+)/;

	public LinuxJoystickMonitor (string joystick_directory) throws IOError {
		this.joystick_directory = joystick_directory;

		// Monitor the directory
		directory = File.new_for_path (joystick_directory);
		monitor = directory.monitor_directory (FileMonitorFlags.NONE);
		monitor.changed.connect (on_changed);
	}

	public string[] get_joysticks () {
		string[] joysticks = {};

		try {
			var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);

			FileInfo file_info;
			while ((file_info = enumerator.next_file ()) != null) {
				var file = directory.get_child (file_info.get_name ());
				if (is_joystick (file))
					joysticks += file.get_path ();
			}
		}
		catch (Error e) {
			printerr ("Error: %s\n", e.message);
		}

		return joysticks;
	}

	private void on_changed (File file, File? other_file, FileMonitorEvent event_type) {
		if (!is_joystick (file))
			return;

		var number = get_joystick_number (file);

		if (number < 0)
			return;

		switch (event_type) {
			case FileMonitorEvent.CREATED:
				var info = file.query_info ("*", FileQueryInfoFlags.NONE);
				if (info.get_attribute_boolean (FileAttribute.ACCESS_CAN_READ))
					joystick_plugged ((uint) number, file.get_path ());
				else
					monitor_can_read (file);
				break;
			case FileMonitorEvent.DELETED:
				joystick_unplugged ((uint) number, file.get_path ());
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
						joystick_plugged (get_joystick_number (file), file.get_path ());
						specific_monitor.disconnect (id);
						specific_monitor.cancel ();
					}
					break;
			}
		});
	}

	private bool is_joystick (File file) {
		if (file.query_file_type (FileQueryInfoFlags.NONE) != FileType.SPECIAL)
			return false;

		if (!name_regex.match (file.get_basename ()))
			return false;

		return true;
	}

	private uint get_joystick_number (File file) {
		var result = name_regex.split (file.get_basename ());
		return (uint) long.parse (result[1]);
	}
}
