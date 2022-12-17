import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceManager {
  final RegExp eSenseRE = RegExp("eSense-\\d\\d\\d\\d");

  ESenseManager _eSenseManager = ESenseManager("INVALID");

  Future<void> connect() async {
    Map<Permission, PermissionStatus> permStat = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
      Permission.location,
    ].request();
    print(permStat);

    if (permStat.containsValue(PermissionStatus.denied) ||
        permStat.containsValue(PermissionStatus.permanentlyDenied)) {
      openAppSettings();
      throw "necessary permission not granted: $permStat";
    }

    String? eSenseName;

    FlutterBlue flutterBlue = FlutterBlue.instance;
    flutterBlue.scanResults.listen((res) {
      for (var device in res) {
        print('found $device');
        var match = eSenseRE.firstMatch(device.device.name);
        if (match != null) {
          flutterBlue.stopScan();
          eSenseName = match.group(0);
        }
      }
    });
    await flutterBlue.startScan(timeout: const Duration(seconds: 10));

    if (eSenseName == null) {
      throw "no eSense device found, regex mismatch";
    }

    _eSenseManager = ESenseManager(eSenseName!);
    _eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');
    });
    bool connecting = await _eSenseManager.connect();
    print("connecting: $connecting");
    await Future.delayed(const Duration(seconds: 5), () {});
  }

  // sensor() {
  //   StreamSubscription subscription =
  //       _eSenseManager.sensorEvents.listen((event) {
  //     print('SENSOR event: $event');
  //   });
  // }

  bool get connected => _eSenseManager.connected;

  Stream<ESenseEvent> get eSenseEvents => _eSenseManager.eSenseEvents;
}

final deviceManager = DeviceManager();
