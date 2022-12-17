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

    deviceManager.eSenseEvents.listen((event) {
      print("ESENSE EVENT FIRED $event");
      setState(() {});
    });
  }

  void connect() async {
    if (!deviceManager.connected) await deviceManager.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            "eSense ${deviceManager.connected ? "connected" : "disconnected"}"),
        MaterialButton(
          onPressed: () {},
          child: Text("verbinden"),
        ),
      ],
    );
  }
}
