if(Socket > -1) network_destroy(Socket);
if(ds_exists(TileMap, ds_type_grid)) ds_grid_destroy(TileMap);
if(ds_exists(ObjMap, ds_type_grid)) ds_grid_destroy(ObjMap);
if(variable_instance_exists(id, "PlrObject")) {
	for(var i = 0; i < NET_PLAYERS; i++) destroy(PlrObject[i]);
}