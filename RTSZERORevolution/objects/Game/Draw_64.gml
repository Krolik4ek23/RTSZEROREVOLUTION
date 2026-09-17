gui_font(fn_default, fa_left, fa_bottom);

gui_text(
	4, 380, 
	"DEBUG:\nNW: " + string(format_size(Game.NetStatWrite)) + 
	" NR: " + string(format_size(Game.NetStatRead)) +
	" FPS: " + string(fps) + " / " + string(fps_real), 
	1, PF, 1);