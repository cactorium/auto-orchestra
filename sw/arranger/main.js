function Note(offset, pitch, duration) {
  this.offset = offset;
  this.pitch = pitch;
  this.duration = duration;
}
Note.prototype.clone = function() {
  return new Note(this.offset, this.pitch, this.duration);
};
Note.prototype.dump = function() {
  return this.offset + ":" + this.pitch + ":" + this.duration;
};
Note.prototype.parse = function(s) {
  var end = s.indexOf(" ");
  if (end == -1) {
    console.log("err: could not parse note in string; no terminating space");
    console.log(s);
    return null;
  }
  var noteStr = s.slice(0, end);
  var parts = noteStr.split(":");
  if (parts.length < 3) {
    console.log("err: could not parse note in string; insufficient separators");
    console.log(noteStr);
  }
  this.offset = Number.parseFloat(parts[0]);
  this.pitch = Number.parseInt(parts[1]);
  this.duration = Number.parseFloat(parts[2]);
  
  return s.slice(end);
};

function eatWhitespace(s) {
  var isWhitespace = function(c) {
    return [' ', '\t', '\r', '\n'].some(function(a) {
      return a == c;
    });
  };
  while (isWhitespace(s[0])) {
    s = s.slice(1);
  }
  return s;
}

function Track(instrument, offset) {
  this.instrument = instrument;
  this.notes = new Array();
  this.offset = offset;
}
Track.prototype.clone = function() {
  var ret = new Track(this.instrument, this.offset);
  ret.notes = new Array(this.notes.length);
  for (var i = 0; i < this.notes.length; i++) {
    ret.notes[i] = this.notes[i].clone();
  }
  return ret;
};
Track.prototype.print = function() {
  var ret = "";
  ret += this.instrument + ":" + this.offset + " {\n";
  for (var i = 0; i < this.notes.length; i++) {
    ret += this.notes[i].dump() + " ";
  }
  ret += "\n}\n";
  return ret;
};
Track.prototype.parse = function(s) {
  s = eatWhitespace(s);
  var end = s.indexOf(" ");
  if (end == -1) {
    console.log("err: could not parse track header in string; no terminating space");
    console.log(s);
    return null;
  }

  var parts = s.slice(0, end).split(":");
  if (parts.length < 2) {
    console.log("err: missing colon in track header");
    console.log(s);
  }
  this.instrument = parts[0];
  this.offset = Number.parseFloat(parts[1]);

  s = s.slice(end);
  s = eatWhitespace(s);
  if (s[0] != "{") {
    console.log("err: could not parse track starting brace");
    console.log(s);
    return null;
  }
  s = s.slice(1);
  s = eatWhitespace(s);

  this.notes = new Array();
  while (s[0] != "}" && s.length > 0) {
    var newNote = new Note(-1, -1, -1);
    s = newNote.parse(s);
    if (s == null) {
      return null;
    }
    s = eatWhitespace(s);
    this.notes.push(newNote);
  }
  if (s.length == 0) {
    console.log("err: unexpected end to track");
    console.log(s);
    return null;
  }
  // eat ending brace
  s = s.slice(1);

  return s;
};

function TrackPlayer(track, offset) {
  this.track = track;
  this.offset = offset;
  this.pos = 0;
  this.bank = OscillatorBank();
  this.notesPlaying = 0;

  // skip notes
  while (this.pos < this.track.notes.length && this.track.notes[this.pos].offset < offset) {
    this.pos++;
  }
}
TrackPlayer.prototype.play = function(offset) {
  if (this.pos < this.track.notes.length || this.notesPlaying > 0) {
    // play any notes that need to be played, and
    // turn off any notes that need to be stopped
    while (this.pos < this.track.notes.length && this.track.notes[this.pos].offset + this.track.offset < offset) {
      this.bank.playNote(this.track.notes[this.pos].pitch);
      this.notesPlaying++;
      this.pos++;
    }
    var me = this;
    this.track.notes.forEach(function(note) {
      // check to see if it needs to be stopped
      var end = note.offset + note.duration;
      //console.log(end, me.offset, offset);
      if (end > me.offset && end <= offset) {
        //console.log("stop " + note.pitch + " " + offset);
        me.bank.stopNote(note.pitch);
        me.notesPlaying--;
      }
    });
    this.offset = offset;
  }
};
TrackPlayer.prototype.stop = function() {
  this.bank.stopAll();
};

/*
function createInstrumentNode(id) {
  var instrumentDiv = document.createElement('div');

  return instrumentDiv;
}

function bindInstrumentNode(rootDiv, id) {
  // TODO
}
*/

function lookupNote(n) {
  var notes = "awsedftgyhujkolp;'";
  return notes.indexOf(n);
}

function lazyEval(f) {
  return function () {
    var ret = null;
    return function() {
      if (ret == null) {
        ret = f();
      }
      return ret;
    };
  }();
}

var sheetArea = lazyEval(function() { return document.getElementById('sheet'); });
var audioContext = lazyEval(function() {
  return new AudioContext({
    latencyHint: 'interactive',
    sampleRate: 44100,
  });
});
var masterVolume = lazyEval(function() {
  var gain = audioContext().createGain();
  gain.connect(audioContext().destination);
  return gain;
});
var tracks = [];

var recordOffset = 0.0;
var selectedInstrument = null;
var playbackWhileRecording = false;
var recordingStarted = false;
var newTrack = null;
var startTime = null;
var pressedNotes = null;

function OscillatorBank() {

  var oscillators = {};
  function sw(freq) {
    var osc = audioContext().createOscillator();
    osc.type = "sine";
    osc.frequency.setValueAtTime(freq, audioContext().currentTime);
    osc.connect(masterVolume());
    return osc;
  }

  function calcFreq(n) {
    return 440*Math.exp(Math.log(2)*(n - 48)/12);
  }


  function playNote(pitch) {
    if (oscillators[pitch] != null) {
      oscillators[pitch].stop();
    }
    var osc = sw(calcFreq(pitch));
    oscillators[pitch] = osc;
    osc.start();
  }

  function stopNote(pitch) {
    if (oscillators[pitch] != null) {
      oscillators[pitch].stop();
      oscillators[pitch] = null;
    }
  }

  function stopAll() {
    Object.keys(oscillators).forEach(function(n) {
      if (oscillators[n]) {
        oscillators[n].stop();
      }
    });
  }

  return {
    playNote: playNote,
    stopNote: stopNote,
    stopAll: stopAll
  };
}

function startRecording() {
  recordingStarted = true;
  if (selectedInstrument == null) {
    selectedInstrument = "instrument0";
  }
  var recordOffsetStr = document.getElementById("record-offset").value;
  recordOffset = Number.parseFloat(recordOffsetStr);
  if (isNaN(recordOffset)) {
    alert("bad offset; please set before continuing");
  }
  newTrack = new Track(selectedInstrument, recordOffset);
  startTime = audioContext().currentTime;
  pressedNotes = {};
}

function stopRecording() {
  recordingStarted = false;
  var endTime = audioContext().currentTime - startTime + recordOffset;
  // stop any notes still being played
  Object.keys(pressedNotes).forEach(function(n) {
    if (pressedNotes[n]) {
      pressedNotes[n].duration = endTime - pressedNotes[n].offset;
    }
  });

  tracks.push(newTrack);
  recordOffset = audioContext().currentTime - startTime + recordOffset;
  document.getElementById("record-offset").value = recordOffset.toString();

  newTrack = null;
  startTime = null;
  pressedNotes = null;

  // dump tracks into the textarea
  dumpTracks(tracks);
}

var isPlaying = false;
var lastStartTime = null;
var currentPlaybackOffset = null;
var timerId = null;
var trackPlayers = null;
function startPlayback() {
  isPlaying = true;
  var recordOffsetStr = document.getElementById("record-offset").value;
  recordOffset = Number.parseFloat(recordOffsetStr);
  if (isNaN(recordOffset)) {
    alert("bad offset; please set before continuing");
  }
  lastStartTime = recordOffset;
  currentPlaybackOffset = audioContext().currentTime - recordOffset;

  trackPlayers = tracks.map(function(t) {
    return new TrackPlayer(t, recordOffset);
  });

  // start callback
  timerId = setInterval(function() {
    var currentOffset = audioContext().currentTime - currentPlaybackOffset;
    document.getElementById("time").textContent = currentOffset;
    if (isPlaying) {
      trackPlayers.forEach(function(tp) {
        tp.play(currentOffset);
      });
    }
  }, 10);
}

function pausePlayback() {
  isPlaying = false;
  if (timerId != null) {
    clearInterval(timerId);
    timerId = null;
  }
  if (trackPlayers != null) {
    trackPlayers.forEach(function(tp) {
      tp.stop();
    });
  }
}

function stopPlayback() {
  // reset time then pause
  currentTime = lastStartTime;
  pausePlayback();
}

function bindKeyboard() {
  var lastNote = null;
  var octave = 4;

  var activeNotes = {};
  var keyboardBank = OscillatorBank();

  if (sheetArea == null) {
    sheetArea = document.getElementById('sheet');
  }
  document.body.addEventListener('keydown', function(e) {
    if (e.target == sheetArea()) {
      return;
    }
    //console.log(e);
    switch (e.key) {
      case 'a': // C
      case 's': // D
      case 'd': // E
      case 'f': // F
      case 'g': // G
      case 'h': // A
      case 'j': // B
      case 'k': // C
      case 'l': // D
      case ';': // E
      case "'": // F
      case 'w': // C#
      case 'e': // D#
      case 't': // F#
      case 'y': // G#
      case 'u': // A#
      case 'o': // C#
      case 'p': // D#
        var note = lookupNote(e.key);
        // skip repeats
        if (lastNote == note) {
          return;
        }
        lastNote = note;
        //console.log(note);
        keyboardBank.playNote(12*octave + note);
        activeNotes[note] = 12*octave + note;

        if (recordingStarted) {
          if (!pressedNotes[note]) {
            var noteOffset = audioContext().currentTime - startTime + recordOffset;
            var newNote = new Note(noteOffset, 12*octave + note, 0.0);
            // save to pressedNotes so it can be updated when it's released
            pressedNotes[note] = newNote;
            // save notes to track
            newTrack.notes.push(newNote);
          }
        }

        break;
      case ' ': // start/stop recording
        if (!recordingStarted) {
          // TODO start playback if that's enabled
          startRecording();
          document.getElementById('state').innerText = "recording";
        } else {
          document.getElementById('state').innerText = "idle";
          stopRecording();
        }
        break;
      case 'x': // up octave
        octave += 1;
        if (octave > 8) octave = 8;
        break;
      case 'z': // down octave
        octave -= 1;
        if (octave < 0) octave = 0;
        break;
      case 'c': // play/pause playback
        if (!isPlaying) {
          startPlayback();
        } else {
          pausePlayback();
        }
        break;
      case 'v': // stop playback
        stopPlayback();
        break;
      default:
        console.log(e);
    }
  });

  document.body.addEventListener('keyup', function(e) {
    if (e.target == sheetArea()) {
      return;
    }
    //console.log(e);
    switch (e.key) {
      case 'a': // C
      case 's': // D
      case 'd': // E
      case 'f': // F
      case 'g': // G
      case 'h': // A
      case 'j': // B
      case 'k': // C
      case 'l': // D
      case ';': // E
      case "'": // F
      case 'w': // C#
      case 'e': // D#
      case 't': // F#
      case 'y': // G#
      case 'u': // A#
      case 'o': // C#
      case 'p': // D#
        var note = lookupNote(e.key);
        // clear the last note if it's released
        if (lastNote == note) {
          lastNote = null;
        }

        if (activeNotes[note]) {
          keyboardBank.stopNote(activeNotes[note]);
        }

        if (recordingStarted) {
          if (pressedNotes[note]) {
            var endTime = audioContext().currentTime - startTime + recordOffset;
            pressedNotes[note].duration = endTime - pressedNotes[note].offset;
            pressedNotes[note] = null;
          } else {
            console.log("w: keyup missing pressed note");
          }
        }
        break;
      default:
        //console.log(e);
    }
  });

}

function bindControls() {

  document.body.addEventListener('input', function() {
    var volumeControl = document.getElementById('master-volume');
    var volumeIndicator = document.getElementById('master-value');
    volumeIndicator.innerText = volumeControl.value + " dB";
    var rawGain = Math.exp(volumeControl.value*Math.log(10)/20);
    masterVolume().gain.setValueAtTime(rawGain, audioContext().currentTime);
  });

  document.getElementById('load-tracks').addEventListener('click', function() {
    var newTracks = [];
    var s = document.getElementById('sheet').value;
    var parseFailed = false;

    while (s != null && s.length > 0) {
      s = eatWhitespace(s);
      var newTrack = new Track('default-instrument', 0);

      s = newTrack.parse(s);
      if (s == null) {
        parseFailed = true;
        break;
      }
      s = eatWhitespace(s);
      newTracks.push(newTrack);
    }

    if (!parseFailed) {
      tracks = newTracks;
    } else {
      alert('track parsing failed; check console log');
    }
  });
}

function dumpTracks(ts) {
  var s = "";
  ts.forEach(function(track) {
    s += track.print();
    s += "\n";
  });

  document.getElementById("sheet").value = s;
}

window.onload = function() {
  // bind keyboard
  bindKeyboard();
  // TODO bind instruments
  // bind controls
  bindControls();
};
