import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceManager {
  final RegExp eSenseRE = RegExp("eSense-\\d\\d\\d\\d");

  ESenseManager? _eSenseManager;

  Future<StreamSubscription<ConnectionEvent>> connect(
      Function(ConnectionEvent) connectionEvents) async {
    Map<Permission, PermissionStatus> permStat = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
      Permission.location,
    ].request();
    if (kDebugMode) {
      print(permStat);
    }

    if (permStat.containsValue(PermissionStatus.denied) ||
        permStat.containsValue(PermissionStatus.permanentlyDenied)) {
      openAppSettings();
      throw "necessary permission not granted: $permStat";
    }

    BluetoothDevice? device;

    FlutterBlue flutterBlue = FlutterBlue.instance;
    var s = flutterBlue.scanResults.listen((res) {
      for (var oneRes in res) {
        if (oneRes.device.name == "") continue;

        if (kDebugMode) {
          print('found ${oneRes.device.name}');
        }

        var match = eSenseRE.firstMatch(oneRes.device.name);
        if (match != null) {
          flutterBlue.stopScan();
          device = oneRes.device;
        }
      }
    });
    await flutterBlue.startScan(timeout: const Duration(seconds: 10));
    s.cancel();

    if (device == null) {
      throw "No eSense device found. Make sure the device is turned on and close to your Smartphone";
    }

    _eSenseManager?.disconnect().ignore();
    _eSenseManager = ESenseManager(device!.name);

    var sub = _eSenseManager!.connectionEvents.listen(connectionEvents);

    bool connecting = await _eSenseManager!.connect();
    if (kDebugMode) {
      print("connecting: $connecting");
    }
    return sub;
  }

  Future<bool> disconnect() async {
    return await _eSenseManager?.disconnect() ?? false;
  }

  /// Only call this when a device is connected
  StreamSubscription<ConnectionEvent> listenConnectionEvents(
      Function(ConnectionEvent) callback) {
    return _eSenseManager!.connectionEvents.listen(callback);
  }

  /// Only call this when a device is connected
  StreamSubscription<SensorEvent> listenSensorEvents(
      Function(SensorEvent) callback) {
    return _eSenseManager!.sensorEvents.listen(callback);
  }

  /// Only call this when a device is connected
  StreamSubscription<ESenseEvent> listenESenseEvents(
      Function(ESenseEvent) callback) {
    return _eSenseManager!.eSenseEvents.listen(callback);
  }

  bool get present => _eSenseManager != null;
  bool get connected => _eSenseManager?.connected ?? false;
}

final deviceManager = DeviceManager();
