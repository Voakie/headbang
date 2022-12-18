import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headbang/device_manager.dart';
import 'package:headbang/model/song.dart';
import 'package:headbang/song_player.dart';

class ESenseBPMGame extends StatefulWidget {
  const ESenseBPMGame({super.key, required this.song});

  final Song song;

  @override
  State<StatefulWidget> createState() => _ESenseBPMGameState();
}

class _ESenseBPMGameState extends State<ESenseBPMGame> {
  StreamSubscription<ConnectionEvent>? _connectionEventsSubscription;
  StreamSubscription<SensorEvent>? _sensorEventsSubscription;

  // Whether a device is connected
  bool _eSenseActive = true;
  // Current direction of nod
  NodDirection _nodDirection = NodDirection.up;
  // Time since last nod direction switch
  int _nodDirectionSwitchTime = DateTime.now().millisecondsSinceEpoch;
  // Time between last two nod direction switches
  int _nodLength = 0;
  // Smoothed version of _nodDirectionLength (smoothed over time)
  double _smoothLength = -1;
  // Current player BPM calculated from nod length
  int _playerBPM = 0;
  // Score of the player
  int _score = 0;

  @override
  void initState() {
    super.initState();
    if (deviceManager.present) {
      _connectionEventsSubscription =
          deviceManager.listenConnectionEvents(_connectionEvents);
      if (deviceManager.connected) {
        _setUpSensors();
        setState(() {
          _eSenseActive = true;
        });
      } else {
        setState(() {
          _eSenseActive = false;
        });
      }
    } else {
      _eSenseActive = false;
    }
  }

  @override
  void dispose() {
    _cleanUpSensors();
    _connectionEventsSubscription?.cancel();
    super.dispose();
  }

  void _connectionEvents(ConnectionEvent event) {
    print("connection event: $event");

    switch (event.type) {
      case ConnectionType.connected:
        setState(() {
          _eSenseActive = true;
        });
        _setUpSensors();
        break;
      case ConnectionType.disconnected:
        setState(() {
          _eSenseActive = false;
        });
        _cleanUpSensors();
        break;
      default:
        setState(() {});
        break;
    }
  }

  void _sensorEvent(SensorEvent event) {
    var nodAxis = event.gyro?[2];
    bool directionChanged = false;

    if (nodAxis != null && songPlayer.playing) {
      if (nodAxis >= 0 && _nodDirection == NodDirection.up) {
        _nodDirection = NodDirection.down;
        directionChanged = true;
      } else if (nodAxis < 0 && _nodDirection == NodDirection.down) {
        _nodDirection = NodDirection.up;
        directionChanged = true;
      }
    }

    if (directionChanged) {
      setState(() {
        var now = DateTime.now().millisecondsSinceEpoch;
        _nodLength = now - _nodDirectionSwitchTime;
        _nodDirectionSwitchTime = now;

        if (_nodLength < 1) _nodLength = 1;

        if (_smoothLength <= 0) {
          _smoothLength = _nodLength.toDouble();
        } else {
          var diff = _nodLength - _smoothLength;
          _smoothLength += diff * 0.05;
        }

        var directBPM = (60000 / (_nodLength * 2)).round();
        var smoothBPM = (60000 / (_smoothLength * 2)).round();

        if ((directBPM - widget.song.bpm).abs() <
            (smoothBPM - widget.song.bpm).abs()) {
          smoothBPM = directBPM;
          _smoothLength = _nodLength.toDouble();
        }

        _playerBPM = smoothBPM;
        _score += _playerPerformance.points;
      });
    }
  }

  void _setUpSensors() {
    _sensorEventsSubscription = deviceManager.listenSensorEvents(_sensorEvent);
  }

  void _cleanUpSensors() async {
    await _sensorEventsSubscription?.cancel();
    _sensorEventsSubscription = null;
  }

  PlayerPerformance get _playerPerformance {
    var diff = (_playerBPM - widget.song.bpm).abs();

    if (diff < 5) {
      return PlayerPerformance.awesome;
    } else if (diff < 10) {
      return PlayerPerformance.good;
    } else if (diff < 20) {
      return PlayerPerformance.medium;
    } else {
      return PlayerPerformance.bad;
    }
  }

  ColorSwatch<int> get _performanceColor {
    var playerPerformance = _playerPerformance;

    if (playerPerformance == PlayerPerformance.awesome) {
      return Colors.green;
    } else if (playerPerformance == PlayerPerformance.good) {
      return Colors.greenAccent;
    } else if (playerPerformance == PlayerPerformance.medium) {
      return Colors.yellowAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_eSenseActive) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
        child: const Text(
          "Return to the main menu to connect to an eSense device",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
      child: Column(
        children: [
          Text(
            _playerBPM.toString(),
            style: TextStyle(
              color: _performanceColor,
              fontSize: 100,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          Text("Dein Score: $_score")
        ],
      ),
    );
  }
}

enum NodDirection {
  up,
  down,
}

enum PlayerPerformance {
  awesome,
  good,
  medium,
  bad,
}

extension ScoredPlayerPerformance on PlayerPerformance {
  int get points {
    if (this == PlayerPerformance.awesome) {
      return 20;
    } else if (this == PlayerPerformance.good) {
      return 10;
    } else if (this == PlayerPerformance.medium) {
      return 5;
    } else {
      return 0;
    }
  }
}
