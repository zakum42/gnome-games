// This file is part of GNOME Games. License: GPLv3

private class Games.GamepadMapping: Object {
	public string id { set; get; }

	private HashTable<uint?, Array<InputMapping?>>[] mappings;

	construct {
		var length = InputType.length ();
		mappings = new HashTable<uint?, Array<InputMapping?>>[length];
		for (int i = 0; i < length; i++)
			mappings[i] = new HashTable<uint?, Array<InputMapping?>> (int_hash, int_equal);
	}

	public void add (InputMapping input_mapping) {
		var src_type = input_mapping.src_type;
		uint index = input_mapping.src_index;

		if (!mappings[src_type].contains (index))
			mappings[src_type][index] = new Array <InputMapping?> ();

		mappings[src_type][index].append_val (input_mapping);
	}

	public void @foreach (Func<InputMapping?> func) {
		foreach (var mappings_per_src_type in mappings)
		foreach (var mappings_per_src in mappings_per_src_type.get_values ())
		for (uint i = 0; i < mappings_per_src.length; i++)
			func (mappings_per_src.index (i));
	}

	public void foreach_source (InputType src_type, uint src_index, Func<InputMapping?> func) {
		return_if_fail (0 <= src_type < InputType.length ());

		uint index = src_index;
		if (!mappings[src_type].contains (index))
			return;

		for (uint i = 0; i < mappings[src_type][index].length; i++)
			func (mappings[src_type][index].index (i));
	}
}
