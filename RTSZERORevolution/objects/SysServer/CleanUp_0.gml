if(Socket > -1) network_destroy(Socket);
if(variable_instance_exists(id, "PlrObject")) {
	for(var i = 0; i < NET_PLAYERS; i++) destroy(PlrObject[i]);
}