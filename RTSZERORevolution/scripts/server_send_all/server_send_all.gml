///@param buff
function server_send_all(argument0) {

	for(var i = 0; i < NET_PLAYERS; i++) {
		if(PlrSocket[i] < 0) continue;
		if(!PlrAuthed[i]) continue;
	
		network_send(argument0, PlrSocket[i]);
	}


}
