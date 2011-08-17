// SETUP

$(document).ready(function() {
    controls.init();
    player.init();    
});

var err = null;


// PLAYER

var player = {
  
    'now_playing': null,
    
    init: function() {
        $("#songlist .song").click(playTrack);
        this.audio = $('#player')[0];
        var a = $(this.audio);
        a.bind('loadstart',         controls.showLoadStart);
        a.bind('loadeddata',        controls.showLoadedData);
        a.bind('canplay',           this.play);
        a.bind('canplaythrough',    controls.showCanPlayThrough);
        a.bind('ended',             this.next);
        a.bind('timeupdate',        this.position);
        a.bind('error',             controls.showError);
        
        this.now_playing = 0;
        this.next();
    },
    
    load: function(url) {
        console.log("player.load");
        this.audio.src = url;
    },

    play: function() {
        // controls.showPlay();
        console.log("canplay");
        controls.playStatus("pause");
        player.audio.play();
    },
    
    pause: function() {
        console.log("player.pause");
        controls.playStatus("play");
        this.audio.pause();
    },

    stop: function() {
        console.log("player.stop");
        this.audio.pause();
        this.audio.currentTime = 0;
    },

    prev: function() {
        var prev_track = $("#song_" + (this.now_playing - 1));
        if (prev_track) {
            prev_track.click();
        };
    },

    next: function() {
        var next_track = $("#song_" + (this.now_playing + 1));
        if (next_track) {
            next_track.click();
        };
        this.position();
    },
    
    // append the given text to the current playing track title
    showTrackRemaining: function(remaining) {
        this.current_track.text(this.current_title + " [" + remaining + "]");
    },


    // calculate the time remaining and append it to the playing track title
    position: function() {
        if (player.audio && player.audio.duration) {
            var remaining = parseInt(player.audio.duration - player.audio.currentTime, 10);
            var pos = Math.floor((player.audio.currentTime / player.audio.duration) * 100);
            var mins = Math.floor(remaining/60,10);
            var secs = remaining - mins*60;
            remaining_time = ('-' + mins + ':' + (secs > 9 ? secs : '0' + secs));
            player.current_track.text(player.current_title + " [" + remaining_time + "]");
        }
    }
}



function playTrack(e) {
    $('#errors').text("");
    if (player.current_track) {
        player.current_track.removeClass('playing');
        player.current_track.text(player.current_title);
    }
    player.current_track = $(this);
    player.current_title = player.current_track.text();
    document.title = player.current_title + " - " + $('#artist').text() + " - " + $('#album').text() + " [" + (player.now_playing + 1) + "/" + $('#songlist').children().size() + "]";
    player.current_track.addClass('playing');
    player.current_track.blur();
    player.load(player.current_track.attr("href"));
    player.now_playing = parseInt(this.id.match(/\d+/));
    var msg = "playTrack: " + player.now_playing + " (" + player.current_title + ")";
    console.log(msg);
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
  
  init: function() {
    this.prev = $('#prev');
    this.play = $('#play');
    this.next = $('#next');
    this.play_label = $('#play').find("span");
    this.prev.click(controls.clickPrev);
    this.play.click(controls.clickPlay);
    this.next.click(controls.clickNext);
  },
  
  clickPlay: function(event) {
    if (player.audio.paused) {
      player.play();
    } else {
      player.pause();
    }
  },
  
  clickNext: function(event) {
    player.next();
  },

  clickPrev: function(event) {
    player.prev();
  },
  
  playStatus: function(txt) {
    this.play_label.text(txt);
  },

  showLoadStart: function() {
    this.showTrackRemaining('0:00');
    console.log("loadstart");
  },

  showLoadedData: function() {
    console.log("loadeddata");
  },

  showCanPlayThrough: function() {
    console.log("canplaythrough");
  },
  
  // yuck. better way to interpret MediaError?
  // http://www.w3.org/TR/html5/video.html
  showError: function(e) {
    console.log("error");
    for (var propName in e.srcElement.error) {
      if (e.srcElement.error[propName] == e.srcElement.error.code) {
        $('#errors').text(propName);
      }
    }
  },
  
  // FIXME: returns 0 in chrome
  showLoadProgress: function() {
    if ((player.audio.buffered != undefined) && (player.audio.buffered.length != 0)) {
      var loaded = parseInt(((player.audio.buffered.end(0) / player.audio.duration) * 100), 10);
      $('#loaded').text(loaded + "%");
    }
  }
}








// UTILITIES

function props(obj) {
    var propList = "";
    for(var propName in obj) {
       if(typeof(obj[propName]) != "undefined") {
          propList += (propName + ":" + obj[propName] + ", ");
       }
    }
    return propList;
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