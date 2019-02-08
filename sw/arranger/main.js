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
  this.startOffset = offset;

  // skip notes
  while (this.pos < this.track.notes.length && this.track.notes[this.pos].offset < offset) {
    this.pos++;
  }
}
TrackPlayer.prototype.play = function(offset) {
  // TODO schedule ahead of time instead of about on time
  if (this.pos < this.track.notes.length || this.notesPlaying > 0) {
    // play any notes that need to be played, and
    // turn off any notes that need to be stopped
    while (this.pos < this.track.notes.length && this.track.notes[this.pos].offset + this.track.offset < offset) {
      console.log("start " + this.track.notes[this.pos].pitch + " " + this.track.notes[this.pos].offset);
      this.bank.playNote(this.track.notes[this.pos].pitch);
      this.notesPlaying++;
      this.pos++;
    }
    this.track.notes.forEach(function(note) {
      // check to see if it needs to be stopped
      var end = note.offset + note.duration;
      //console.log(end, me.offset, offset);
      if (end > this.offset && end <= offset && note.offset >= this.startOffset) {
        console.log("stop " + note.pitch);
        //console.log("stop " + note.pitch + " " + offset);
        this.bank.stopNote(note.pitch);
        this.notesPlaying--;
      }
    }, this);
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

var Metronome = function() {
  var metronomeBuffer = function() {
    var lastBpm = null;
    var lastBuffer = null;
    return function(bpm) {
      if (bpm == lastBpm) {
        return lastBuffer;
      }
      lastBuffer = audioContext().createBuffer(1, 44100 * 60/bpm, 44100);
      var channel = lastBuffer.getChannelData(0);
      for (var i = 0; i < channel.length; i++) {
        channel[i] = Math.exp(-5*i/44100.)*Math.sin(2*Math.pi*2e+3*i/44100.);
      }

      lastBpm = bpm;
      return lastBuffer;
    };
  }();
  var metronomeGain = lazyEval(function() {
    var gain = audioContext().createGain();
    gain.connect(audioContext().destination);
    return gain;
  });
  var metronomeNode = function(audioTime, bpm) {
    node = new AudioSourceNode(audioContext(), {
      buffer: metronomeBuffer(bpm),
    });
    node.connect(metronomeGain());
    // NOTE: caller needs to use start() to schedule the node
    return node;
  };

  function startMetronome(bpm, offset) {
    this.callbackId = setInterval(function() {
      // TODO
    }, 60e+3/bpm);
    this.isPlaying = true;
  }
  function stopMetronome() {
    this.isPlaying = false;
    // turn off interval
    clearInterval(this.callbackId);
  }

  return {
    start: startMetronome,
    stop: stopMetronome,
    isPlaying: false,
    callbackId: null
  };
}();

var tracks = [];

function OscillatorBank() {

  var osc = audioContext().createOscillator();
  osc.type = "sine";
  var muter = audioContext().createGain();
  osc.frequency.setValueAtTime(440, audioContext().currentTime);
  muter.gain.setValueAtTime(0, audioContext().currentTime);
  muter.connect(masterVolume());
  osc.connect(muter);
  osc.start();

  var lastPitch = null;

  function calcFreq(n) {
    return 440*Math.exp(Math.log(2)*(n - 48)/12);
  }

  function playNote(pitch, time) {
    time = time || audioContext().currentTime;
    osc.frequency.setValueAtTime(calcFreq(pitch), time);
    muter.gain.setValueAtTime(1, time);
    lastPitch = pitch;
  }

  function stopNote(pitch) {
    if (lastPitch == pitch || pitch == null) {
      muter.gain.setValueAtTime(0, audioContext().currentTime);
    }
  }

  function stopAll() {
    stopNote(null);
  }

  return {
    playNote: playNote,
    stopNote: stopNote,
    stopAll: stopAll,
    oscilllator: osc
  };
}

var Recorder = function() {
  var recordOffset = 0.0;
  var selectedInstrument = null;
  var newTrack = null;
  var startTime = null;

  function startRecording(offset) {
    this.isRecording = true;
    if (selectedInstrument == null) {
      selectedInstrument = "instrument0";
    }
    recordOffset = offset;
    newTrack = new Track(selectedInstrument, recordOffset);
    startTime = audioContext().currentTime;
    this.pressedNotes = {};
  }

  function stopRecording() {
    this.isRecording = false;
    var endTime = audioContext().currentTime - startTime + recordOffset;
    // stop any notes still being played
    Object.keys(this.pressedNotes).forEach(function(n) {
      if (this.pressedNotes[n]) {
        this.pressedNotes[n].duration = endTime - this.pressedNotes[n].offset;
      }
    }, this);

    tracks.push(newTrack);
    recordOffset = audioContext().currentTime - startTime + recordOffset;
    document.getElementById("offset").value = recordOffset.toString();

    newTrack = null;
    startTime = null;
    this.pressedNotes = null;

    // dump tracks into the textarea
    dumpTracks(tracks);
  }

  function recordNote(octave, note) {
    if (!this.pressedNotes[note]) {
      var endTime = audioContext().currentTime - startTime + recordOffset;
      // mark any currently pressed notes as done
      var me = this;
      Object.keys(this.pressedNotes).forEach(function(n) {
        if (this.pressedNotes[n]) {
          this.pressedNotes[n].duration = endTime - this.pressedNotes[n].offset;
          this.pressedNotes[n] = null;
        }
      }, this);

      var noteOffset = audioContext().currentTime - startTime + recordOffset;
      var newNote = new Note(noteOffset, 12*octave + note, 0.0);
      // save to pressedNotes so it can be updated when it's released
      this.pressedNotes[note] = newNote;
      // save notes to track
      newTrack.notes.push(newNote);
    }
  }

  function recordNoteEnd(note) {
    if (this.pressedNotes[note]) {
      var endTime = audioContext().currentTime - startTime + recordOffset;
      this.pressedNotes[note].duration = endTime - this.pressedNotes[note].offset;
      this.pressedNotes[note] = null;
    }
  }
  return {
    start: startRecording,
    stop: stopRecording,
    record: recordNote,
    recordNoteEnd: recordNoteEnd,
    isRecording: false,
    pressedNotes: null,
  };
}();

var isPlaying = false;
var lastStartTime = null;
var currentPlaybackOffset = null;
var timerId = null;
var trackPlayers = null;
function startPlayback(offset) {
  isPlaying = true;
  lastStartTime = offset;
  currentPlaybackOffset = audioContext().currentTime - offset;

  trackPlayers = tracks.map(function(t) {
    return new TrackPlayer(t, offset);
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
    if (e.target == sheetArea() || e.target.tagName == 'INPUT') {
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
        //console.log(note);
        keyboardBank.playNote(12*octave + note);
        activeNotes[note] = 12*octave + note;

        if (Recorder.isRecording) {
          Recorder.record(octave, note);
        }
        lastNote = note;

        break;
      case ' ': // start/stop recording
        if (!Recorder.isRecording) {
          var recordOffsetStr = document.getElementById("offset").value;
          var offset = Number.parseFloat(recordOffsetStr);
          if (isNaN(offset)) {
            alert("bad offset; please set before continuing");
          }

          Recorder.start(offset);

          // start playback if that's enabled
          if (document.getElementById('record-playback').checked) {
            startPlayback(offset);
          }
          // same for metronome
          if (document.getElementById('metronome-en').checked) {
            var bpm = Number.parseInt(document.getElementById('metronome-bpm').value);
            Metronome.start(bpm, offset);
          }
          document.getElementById('state').innerText = "recording";
        } else {
          document.getElementById('state').innerText = "idle";
          if (isPlaying) {
            stopPlayback();
          }
          if (Metronome.isPlaying) {
            Metronome.stop();
          }
          Recorder.stop();
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
          var recordOffsetStr = document.getElementById("offset").value;
          var offset = Number.parseFloat(recordOffsetStr);
          if (isNaN(offset)) {
            alert("bad offset; please set before continuing");
          }

          startPlayback(offset);
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
    if (e.target == sheetArea() || e.target.tagName == 'INPUT') {
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

        if (Recorder.isRecording) {
          Recorder.recordNoteEnd(note);
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
    loadTracks();
  });

  document.getElementById('save-tracks').addEventListener('click', function() {
    var storage = window.localStorage;
    storage.setItem('tracks', document.getElementById('sheet').value);
    storage.setItem('volume', document.getElementById('master-volume').value.toString());
  });

  document.getElementById('record-playback').addEventListener('click', function() {
    var storage = window.localStorage;
    storage.setItem('playback-sync', document.getElementById('record-playback').checked);
  });
  document.getElementById('metronome-en').addEventListener('click', function() {
    var storage = window.localStorage;
    storage.setItem('metronome-en', document.getElementById('metronome-en').checked);
  });
  document.getElementById('metronome-bpm').addEventListener('input', function() {
    var storage = window.localStorage;
    storage.setItem('metronome-bpm', document.getElementById('metronome-bpm').value);
  });

}

function loadTracks() {
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
}


function dumpTracks(ts) {
  var s = "";
  ts.forEach(function(track) {
    s += track.print();
    s += "\n";
  });

  document.getElementById("sheet").value = s;
}

function initStuff() {
  var storage = window.localStorage;
  var storedTracks = storage.getItem("tracks");
  if (storedTracks && storedTracks.length > 0) {
    document.getElementById('sheet').value = storedTracks;
    loadTracks();
  }

  var volumeSetting = storage.getItem("volume");
  if (volumeSetting) {
    var volumeControl = document.getElementById('master-volume');
    volumeControl.value = Number.parseFloat(volumeSetting);

    volumeIndicator = document.getElementById('master-value');
    volumeIndicator.innerText = volumeControl.value + " dB";
    var rawGain = Math.exp(volumeControl.value*Math.log(10)/20);
    masterVolume().gain.setValueAtTime(rawGain, audioContext().currentTime);
  }
  var playbackSetting = storage.getItem('playback-sync');
  if (playbackSetting) {
    if (playbackSetting == 'true') {
      document.getElementById('record-playback').checked = true;
    }
  }
}

window.onload = function() {
  // bind keyboard
  bindKeyboard();
  // TODO bind instruments
  // bind controls
  bindControls();

  initStuff();
};
