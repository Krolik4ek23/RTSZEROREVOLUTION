if(Socket > -1) network_destroy(Socket);
if(Minimap != NOTEXTURE) sprite_delete(Minimap);
if(GameMapPreview != NOTEXTURE) sprite_delete(GameMapPreview);
if(surface_exists(SurfShroud)) surface_free(SurfShroud);
if(surface_exists(SurfShadow)) surface_free(SurfShadow);
if(ds_exists(TileMap, ds_type_grid)) ds_grid_destroy(TileMap);
if(ds_exists(ObjMap, ds_type_grid)) ds_grid_destroy(ObjMap);
ds_list_destroy(Chat);
ds_list_destroy(Pick);
if(variable_instance_exists(id, "PlrObject")) {
	for(var i = 0; i < NET_PLAYERS; i++) destroy(PlrObject[i]);
}