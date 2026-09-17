function net_generate_uid() {
	while(true) {
		var GenUid = irandom(65000);
	
		with(Civilian) {
			if(NetUID == GenUid) {
				GenUid = 0;
				break;
			}
		}
	
		if(GenUid) return GenUid;
	}


}
