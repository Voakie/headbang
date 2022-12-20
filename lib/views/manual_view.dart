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
        children: [
          const Padding(
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
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 15),
                children: [
                  TextSpan(
                      text:
                          "Created for the Mobile Computing and Internet of Things lecture at KIT."),
                  TextSpan(text: "\n\n"),
                  TextSpan(
                      text:
                          "This app measures the headbangs of the user using the gyroscope in the connected eSense earable. The user can listen to predefined songs or set their own BPM target, to see how well they can match it. The score is computed by awarding the player on each headbang with...\n\n"),
                  TextSpan(text: "  20 points for < 5 BPM error\n"),
                  TextSpan(text: "  10 points for < 10 BPM error\n"),
                  TextSpan(text: "  5 points for < 20 BPM error\n"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
