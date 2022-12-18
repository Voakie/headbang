import 'package:flutter/material.dart';

class ManualView extends StatelessWidget {
  const ManualView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
      ),
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "headbang",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "In dieser App geht es darum, mit einem eSense Earable die eigenen Nickbewegungen zur abgespielten Musik aufzuzeichnen. Dabei wird der BPM des Nickens mit der BPM des Liedes verglichen. Je nachdem wie gut der Spieler im Takt liegt, steigt der Punktestand umso schneller.",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
