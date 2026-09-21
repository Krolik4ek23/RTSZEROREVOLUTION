// Временная заглушка (жёлтая точка), пока спрайт sprShot не нарисован
draw_circle_color(x, y, 2, c_yellow, c_yellow, 0);

draw_sprite_ext(sprShot, 0, x, y, 1, 1, point_direction(x, y, ToX, ToY), c_white, 1);
