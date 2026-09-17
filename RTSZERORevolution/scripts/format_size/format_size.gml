///@param bytes
function format_size(argument0) {

	var DivNames = ["б", "кб", "мб", "гб", "тб"];
	var DivNum = 0;

	while(argument0 > 1023) {
		argument0 /= 1024;
		DivNum++;
	}

	return (string(argument0) + DivNames[DivNum]);


}
