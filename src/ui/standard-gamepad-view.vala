// This file is part of GNOME Games. License: GPLv3

private class Games.StandardGamepadView : Gtk.DrawingArea {
	private const Gtk.StateFlags DEFAULT_STATE = Gtk.StateFlags.NORMAL;
	private const Gtk.StateFlags HIGHLIGHT_STATE = Gtk.StateFlags.LINK;

	private bool[] button_lightning;

	private static const double TAU = Math.PI * 2;

	private Cairo.Context cr;

	private Gamepad _gamepad;
	private ulong button_event_id;
	public Gamepad gamepad {
		set {
			if (_gamepad != null)
				_gamepad.disconnect (button_event_id);

			_gamepad = value;

			if (_gamepad != null)
				button_event_id = _gamepad.gamepad_button_event.connect (on_button_event);
		}
	}

	construct {
		button_lightning = new bool[17];
	}

	public void highlight_button (StandardGamepadButton button, bool highlighted) {
		button_lightning[button] = highlighted;
		queue_draw ();
	}

	public void reset () {
		var length = StandardGamepadButton.length ();
		for (uint button = 0 ; button < length  ; button++)
			highlight_button ((StandardGamepadButton) button, false);
	}

	private void render (StandardGamepadButton button) {
		var state = button_lightning[button] ? HIGHLIGHT_STATE : DEFAULT_STATE;
		var color = get_style_context ().get_color (state);
		cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);

		cr.fill ();
	}

	public override bool draw (Cairo.Context cr) {
		this.cr = cr;
		var width = get_allocated_width ();
		var height = get_allocated_height ();

		draw_gamepad (width, height);

		return false;
	}

	private void draw_gamepad (int width, int height) {
		double x, y, w, h;
		if (width * 3 > height * 4) {
			// The bounding box is wider than tall
			h = (double) height;
			w = h * 4/3;
			y = 0.0;
			x = ((double) width - w) / 2;
		}
		else {
			// The bounding box is taller than wide
			w = (double) width;
			h = w * 3/4;
			x = 0.0;
			y = ((double) height - h) / 2;
		}

		var mid_h = y + h*0.55;

		draw_dpad (x + w*0.2, mid_h, w*0.2);
		draw_action_buttons (x + w*0.8, mid_h, w*0.25);
		draw_control_buttons (x + w/2.0, mid_h, w*0.1);
		draw_shoulders (x + w/2.0, y + h*0.2, w/5, w/15, w*0.3, w/20);
		draw_joysticks (x + w/2.0, y + h*0.8, w*0.08, w/3.0);
	}

	private void draw_dpad (double xc, double yc, double side) {
		var width = side / 3;
		var w_shift = side / 6;
		var l_shift = side / 2;

		// Draw a square in the middle to avoid seeing demaraction lines
		var color = get_style_context ().get_color (DEFAULT_STATE);
		cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);

		cr.rectangle (xc - w_shift, yc - w_shift, width, width);
		cr.fill ();

		cr.move_to (xc, yc);
		cr.line_to (xc - w_shift, yc - w_shift);
		cr.line_to (xc - w_shift, yc - l_shift);
		cr.line_to (xc + w_shift, yc - l_shift);
		cr.line_to (xc + w_shift, yc - w_shift);
		cr.line_to (xc, yc);
		render (StandardGamepadButton.DPAD_UP);

		cr.move_to (xc, yc);
		cr.line_to (xc - w_shift, yc + w_shift);
		cr.line_to (xc - w_shift, yc + l_shift);
		cr.line_to (xc + w_shift, yc + l_shift);
		cr.line_to (xc + w_shift, yc + w_shift);
		cr.line_to (xc, yc);
		render (StandardGamepadButton.DPAD_DOWN);

		cr.move_to (xc, yc);
		cr.line_to (xc - w_shift, yc - w_shift);
		cr.line_to (xc - l_shift, yc - w_shift);
		cr.line_to (xc - l_shift, yc + w_shift);
		cr.line_to (xc - w_shift, yc + w_shift);
		cr.line_to (xc, yc);
		render (StandardGamepadButton.DPAD_LEFT);

		cr.move_to (xc, yc);
		cr.line_to (xc + w_shift, yc - w_shift);
		cr.line_to (xc + l_shift, yc - w_shift);
		cr.line_to (xc + l_shift, yc + w_shift);
		cr.line_to (xc + w_shift, yc + w_shift);
		cr.line_to (xc, yc);
		render (StandardGamepadButton.DPAD_RIGHT);
	}

	private void draw_action_buttons (double xc, double yc, double side) {
		var radius = side / 6;
		var shift = side / 3;

		circle (xc, yc + shift, radius);
		render (StandardGamepadButton.A);

		circle (xc + shift, yc, radius);
		render (StandardGamepadButton.B);

		circle (xc - shift, yc, radius);
		render (StandardGamepadButton.X);

		circle (xc, yc - shift, radius);
		render (StandardGamepadButton.Y);
	}

	private void draw_control_buttons (double xc, double yc, double radius) {
		circle (xc, yc, radius / 2.0);
		render (StandardGamepadButton.HOME);

		circle (xc - radius, yc, radius / 3.0);
		render (StandardGamepadButton.SELECT);

		circle (xc + radius, yc, radius / 3.0);
		render (StandardGamepadButton.START);
	}

	private void draw_shoulders (double xc, double yc, double w, double h, double h_shift, double v_shift) {
		double h_spacing = h_shift - w / 2.0;
		double v_spacing = v_shift - h / 2.0;

		cr.rectangle (xc - h_spacing - w, yc + v_spacing, w, h);
		render (StandardGamepadButton.SHOULDER_L);

		cr.rectangle (xc + h_spacing, yc + v_spacing, w, h);
		render (StandardGamepadButton.SHOULDER_R);

		cr.rectangle (xc - h_spacing - w, yc - v_spacing - h, w, h);
		render (StandardGamepadButton.TRIGGER_L);

		cr.rectangle (xc + h_spacing, yc - v_spacing -h, w, h);
		render (StandardGamepadButton.TRIGGER_R);
	}

	private void draw_joysticks (double xc, double yc, double radius, double spacing) {
		circle (xc - spacing/2.0, yc, radius);
		render (StandardGamepadButton.STICK_L);
		circle (xc + spacing/2.0, yc, radius);
		render (StandardGamepadButton.STICK_R);
	}

	private void circle (double xc, double yc, double radius) {
		cr.arc (xc, yc, radius, 0, TAU);
	}

	private void on_button_event (GamepadButtonEvent event) {
		var button = (StandardGamepadButton) event.button;
		highlight_button (button, event.value.pressed);
	}
}
