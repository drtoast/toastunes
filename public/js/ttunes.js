$(document).ready(function() {
	
	// adapted from http://www.happyworm.com/jquery/jplayer/latest/demo-04.htm
	var jpPlayInfo = $("#play-info");
	var jpStatus = $("#status"); // For displaying information about jPlayer's status
	var position = $("#position"); // the current playback position
	var now_playing;

	$("#jquery_jplayer").jPlayer({
		ready: function () {
			$("#song_1").trigger("click");
		},
		customCssIds: true
	})
	.jPlayer("cssId", "play", "play")
	.jPlayer("cssId", "pause", "pause")
	.jPlayer("cssId", "stop", "stop")
	.jPlayer("cssId", "volumeMin", "vmin")
	.jPlayer("cssId", "volumeMax", "vmax")
	.jPlayer("cssId", "volumeBar", "vbar")
	.jPlayer("onProgressChange", function(lp,ppr,ppa,pt,tt) {
 		jpPlayInfo.text("at " + parseInt(ppa)+"% of " + $.jPlayer.convertTime(tt) + ", which is " + $.jPlayer.convertTime(pt));
		playedPercent(this.element, position);
		// demoStatusInfo(this.element, jpStatus);
	})
	.jPlayer("onSoundComplete", function() {
		playNext();
	});

	$(".song").click( changeTrack );

	$("#prev").click( function() {
		playPrev();
		$(this).blur();
		return false;
	});

	$("#next").click( function() {
		playNext();
		$(this).blur();
		return false;
	});


	function changeTrack(e) {
		var previous_track = $("#song_" + now_playing);
		if (previous_track) {
			previous_track.removeClass('playing');
		};
		
		$("#jquery_jplayer").jPlayer("setFile", $(this).attr("href")).jPlayer("play");
		$(this).addClass('playing');
		$(this).blur();
		now_playing = parseInt(this.id.match(/\d+/));
		console.log("now playing: " + now_playing);
		return false;
	}
	
	function playNext() {
		var sel = "#song_" + (now_playing + 1)
		var next_track = $(sel);
		if (next_track) {
			next_track.click();
		};
	}
	
	function playPrev() {
		var sel = "#song_" + (now_playing - 1)
		var next_track = $(sel);
		if (next_track) {
			next_track.click();
		};
	}

	$.jPlayer.timeFormat.padMin = false;
	$.jPlayer.timeFormat.padSec = false;
	$.jPlayer.timeFormat.sepMin = "min ";
	$.jPlayer.timeFormat.sepSec = "sec";

	function playedPercent(myPlayer) {
		var pct = Math.floor(myPlayer.jPlayer("getData", "diag.playedPercentAbsolute")) + "%"
		position.text(pct)
	}

	function demoStatusInfo(myPlayer, myInfo) {
	    var jPlayerStatus = "<p>jPlayer is ";
	    jPlayerStatus += (myPlayer.jPlayer("getData", "diag.isPlaying") ? "playing" : "stopped");
	    jPlayerStatus += " at time: " + Math.floor(myPlayer.jPlayer("getData", "diag.playedTime")) + "ms.";
	    jPlayerStatus += " (tt: " + Math.floor(myPlayer.jPlayer("getData", "diag.totalTime")) + "ms";
	    jPlayerStatus += ", lp: " + Math.floor(myPlayer.jPlayer("getData", "diag.loadPercent")) + "%";
	    jPlayerStatus += ", ppr: " + Math.floor(myPlayer.jPlayer("getData", "diag.playedPercentRelative")) + "%";
	    jPlayerStatus += ", ppa: " + Math.floor(myPlayer.jPlayer("getData", "diag.playedPercentAbsolute")) + "%)</p>"
	    myInfo.html(jPlayerStatus);
	}


})
