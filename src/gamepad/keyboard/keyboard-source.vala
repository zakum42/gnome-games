// This file is part of GNOME Games. License: GPLv3

private class Games.KeyboardSource: Object, GamepadSource {
	private KeyboardDevice keyboard;

	public KeyboardSource (KeyboardDevice keyboard) {
		this.keyboard = keyboard;
	}

	public void @foreach (Func<Gamepad> func) {
		var mapping_dir = Application.get_keyboard_mappings_dir ();
		var monitor = new DirectoryMonitor (mapping_dir, /.*\.mapping\.xml/);
		monitor.foreach ((uri) => {
			var file = File.new_for_uri (uri);
			var path = file.get_path ();

			var doc = new MappingDoc.from_file (path);
			doc.foreach_mapping_node ((mapping_node) => {
				var gamepad_node = mapping_node.get_parent ();
				var id = gamepad_node.get_prop ("id");

				var mapping = new KeyboardMapping ();
				var gamepad = new KeyboardGamepad (keyboard);
				gamepad.mapping = mapping;

				mapping_node.foreach_input_mapping ((input_mapping) => {
					mapping.add (input_mapping);
				});

				func (gamepad);
			});
		});
	}
}
