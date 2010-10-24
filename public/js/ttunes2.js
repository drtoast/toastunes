function ctx() {

}

$(document).ready(function() {
	canvas = document.getElementById('canvas');
	var ctx = canvas.getContext('2d');
	ctx.fillRect(5,5,100,10);
}