if(Socket > -1) network_destroy(Socket);
if(Minimap != NOTEXTURE) sprite_delete(Minimap);
surface_free(SurfShroud);
ds_list_destroy(Chat);
ds_list_destroy(Pick);