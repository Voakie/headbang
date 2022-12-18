import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headbang/device_manager.dart';

class EsenseStatusView extends StatefulWidget {
  const EsenseStatusView({super.key});

  @override
  State<StatefulWidget> createState() => _EsenseStatusViewState();
}

class _EsenseStatusViewState extends State<EsenseStatusView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cleanUpOldConnection();
    super.dispose();
  }

  StreamSubscription<ConnectionEvent>? _connectionEventsSubscription;

  bool _connecting = false;

  void _connectionEvents(ConnectionEvent event) {
    print("connection event: $event");

    switch (event.type) {
      case ConnectionType.connected:
        setState(() {
          _connecting = false;
        });
        break;
      case ConnectionType.disconnected:
        setState(() {
          _connecting = false;
        });
        _cleanUpOldConnection();
        break;
      case ConnectionType.device_found:
        setState(() {
          _connecting = true;
        });
        break;
      case ConnectionType.unknown:
        break;
      default:
        setState(() {
          _connecting = false;
        });
        break;
    }
  }

  void connect() async {
    if (!deviceManager.connected) {
      setState(() {
        _connecting = true;
      });

      await _cleanUpOldConnection();

      try {
        _connectionEventsSubscription =
            await deviceManager.connect(_connectionEvents);
      } catch (e) {
        print(
            "Exception occurred in connect(): $e. DEVICE STATUS: Connected: ${deviceManager.connected}");
        setState(() {
          _connecting = false;
        });
      }
    }
  }

  void disconnect() {
    if (deviceManager.connected) {
      setState(() {
        _connecting = true;
      });

      deviceManager.disconnect().ignore();
    }
  }

  Future<void> _cleanUpOldConnection() async {
    await _connectionEventsSubscription?.cancel();
    _connectionEventsSubscription = null;
  }

  Widget rightContent() {
    if (_connecting) {
      return const Padding(
        padding: EdgeInsets.all(6),
        child: CircularProgressIndicator(),
      );
    } else if (deviceManager.connected) {
      return ElevatedButton(
        onPressed: disconnect,
        child: const Text("Trennen"),
      );
    } else {
      return ElevatedButton(
        onPressed: connect,
        child: const Text("Verbinden"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "eSense ${deviceManager.connected ? "verbunden" : "nicht verbunden"}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: deviceManager.connected
                  ? Colors.greenAccent
                  : Colors.orangeAccent,
            ),
          ),
          rightContent(),
        ],
      ),
    );
  }
}
