///@param socket
///@param [reason]
function server_disconnect(argument0, argument1) {

	var socket = argument0,
		reason = argument1;

	begin
		network_packet(BUFF1, NetPacket.Disconnecting);
		buffer_write(BUFF1, buffer_string, reason);
		network_send(BUFF1, socket);
	
		network_destroy(socket);
	
		for(var i = 0; i < NET_PLAYERS; i++) {
			if(PlrSocket[i] != socket) continue;
		
			PlrSocket[i] = -1;
			PlrAuthed[i] = false;
			PlrObject[i].Color = 0;
			PlrObject[i].Username = "";
			break;
		}
	end;


}
