NetUID = 0;if(SERVER_SIDE) NetUID = net_generate_uid();
HasNetEvent = false;
OutlineRadius = max(sprite_width, sprite_height, 4) * 0.7;
VisionRadius = 4;

Abilities = array_create(9, 0);

MaxHP = 1;
HP = MaxHP;
Plr = Game.NeutralPlayer;

IsAlive = true;