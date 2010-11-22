// SETUP

$(document).ready(function() {
    controls.init();
    player.init();
});



// PLAYER

var player = {
    'now_playing': null
}

player.init = function() {
    $("#songlist .song").click(playTrack);
    player.audio = $('#player')[0];
    $(player.audio).bind('ended',player.next);
    $(player.audio).bind('timeupdate',player.position);
    player.now_playing = 0;
    player.next();
}

player.load = function(url) {
    player.audio.src = url;
}

player.play = function() {
    player.audio.play();
}

player.pause = function() {
    player.audio.pause();
}

player.stop = function() {
    player.audio.pause();
    player.audio.currentTime = 0;
}

player.prev = function() {
    var prev_track = $("#song_" + (player.now_playing - 1));
    if (prev_track) {
        prev_track.click();
    };
}

player.next = function() {
    var next_track = $("#song_" + (player.now_playing + 1));
    if (next_track) {
        next_track.click();
    };
    player.position();
}

player.duration = function() {
    player.audio.duration;
}

player.position = function() {
    var remaining_time = "0:00";
    if (player.audio.duration) {
        var remaining = parseInt(player.audio.duration - player.audio.currentTime, 10);
        var pos = Math.floor((player.audio.currentTime / player.audio.duration) * 100);
        var mins = Math.floor(remaining/60,10);
        var secs = remaining - mins*60;
        remaining_time = ('-' + mins + ':' + (secs > 9 ? secs : '0' + secs));
        player.current_track.text(player.current_title + " [" + remaining_time + "]");
    }
}

function playTrack(e) {
    var previous_track = $("#song_" + player.now_playing);
    if (previous_track) {
        previous_track.removeClass('playing');
    };
    if (player.current_track) {
        player.current_track.text(player.current_title);
    }
    player.current_track = $(this);
    player.current_title = player.current_track.text();
    player.load(player.current_track.attr("href"));
    $(controls.play).find("span").text("pause");
    player.play();
    player.current_track.addClass('playing');
    player.current_track.blur();
    player.now_playing = parseInt(this.id.match(/\d+/));
    console.log("now playing: " + player.now_playing + " (" + player.current_title + ")");
    return false;
}



// CONTROLS

var controls = {
    'button_width':         50,
    'button_height':        24.5,
    'button_padding':       6,
    'button_background':    '#ddd',
    'button_stroke':        '#333',
    'controls_background':  "#bbb",
}

controls.init = function() {
    controls.prev = $('#prev');
    controls.play = $('#play');
    controls.next = $('#next');

    $(controls.prev).click(controls.clickPrev);
    $(controls.play).click(controls.clickPlay);
    $(controls.next).click(controls.clickNext);
}

controls.clickPlay = function(event) {
    if (player.audio.paused) {
        console.log("playing");
        player.play();
        
    } else {
        console.log("pausing");
        player.pause();
        $(controls.play).find("span").text("play");
    }
}

controls.clickNext = function(event) {
    player.next();
}

controls.clickPrev = function(event) {
    player.prev();
}


// DRAWING

controls.drawControls = function() {
    controls.drawButton(controls.prev.getContext('2d'), '<');
    controls.drawButton(controls.next.getContext('2d'), '>');
    controls.drawPlay('play');
}

controls.drawPlay = function(label) {
    controls.drawButton(controls.play.getContext('2d'), label);
}

controls.drawButton = function(ctx,label) {
    ctx.fillStyle = controls.button_background;
    ctx.strokeStyle = controls.button_stroke;
    controls.roundedRect(ctx,0,0,controls.button_width,controls.button_height,10);
    //ctx.fillRect(0,0,controls.button_width,controls.button_height);
    ctx.fillStyle = "black";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText(label, controls.button_width / 2, controls.button_height / 2);
}

controls.roundedRect = function(ctx,x,y,width,height,radius) {
  ctx.beginPath();
  ctx.moveTo(x,y+radius);
  ctx.lineTo(x,y+height-radius);
  ctx.quadraticCurveTo(x,y+height,x+radius,y+height);
  ctx.lineTo(x+width-radius,y+height);
  ctx.quadraticCurveTo(x+width,y+height,x+width,y+height-radius);
  ctx.lineTo(x+width,y+radius);
  ctx.quadraticCurveTo(x+width,y,x+width-radius,y);
  ctx.lineTo(x+radius,y);
  ctx.quadraticCurveTo(x,y,x,y+radius);
  ctx.fill();
  ctx.stroke();
}