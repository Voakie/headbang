import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headbang/device_manager.dart';
import 'package:headbang/model/song.dart';
import 'package:headbang/model/song_player.dart';

class ESenseBPMGame extends StatefulWidget {
  const ESenseBPMGame({super.key, required this.song});

  final Song song;

  @override
  State<StatefulWidget> createState() => _ESenseBPMGameState();
}

class _ESenseBPMGameState extends State<ESenseBPMGame> {
  StreamSubscription<ConnectionEvent>? _connectionEventsSubscription;
  StreamSubscription<SensorEvent>? _sensorEventsSubscription;

  bool _eSenseActive = true;
  NodDirection _nodDirection = NodDirection.up;
  int _nodDirectionSwitchTime = DateTime.now().millisecondsSinceEpoch;
  int _nodDirectionLength = 0;
  double _smoothLength = -1;
  int _playerBPM = 0;

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
        _nodDirectionLength = now - _nodDirectionSwitchTime;
        _nodDirectionSwitchTime = now;

        if (_smoothLength <= 0) {
          _smoothLength = _nodDirectionLength.toDouble();
        } else {
          var diff = _nodDirectionLength - _smoothLength;
          _smoothLength += diff * 0.05;
        }

        if (_nodDirectionLength < 1) _nodDirectionLength = 1;

        var directBPM = (60000 / (_nodDirectionLength * 2)).round();
        var smoothBPM = (60000 / (_smoothLength * 2)).round();

        if ((directBPM - widget.song.bpm).abs() <
            (smoothBPM - widget.song.bpm).abs()) {
          smoothBPM = directBPM;
          _smoothLength = _nodDirectionLength.toDouble();
        }

        if (smoothBPM > 100 && smoothBPM < 60000) {
          _playerBPM = smoothBPM;
        }
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
      child: Text(
        _playerBPM.toString(),
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum NodDirection {
  up,
  down,
}
