// Временная заглушка (серая точка), пока спрайт sprTrack не нарисован
draw_set_alpha(0.45);
draw_circle_color(x, y, 3, c_gray, c_gray, 0);
draw_set_alpha(1);

draw_sprite_ext(sprTrack, 0, x, y, 1, 1, image_angle, c_white, 0.6);
