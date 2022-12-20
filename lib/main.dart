import 'package:flutter/material.dart';
import 'package:headbang/views/esense_status_view.dart';
import 'package:headbang/views/manual_view.dart';
import 'package:headbang/views/song_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void openManual(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ManualView()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Choose a Song"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Builder(
                builder: (context) => IconButton(
                  onPressed: () => openManual(context),
                  icon: const Icon(Icons.info_outline),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: const [
            EsenseStatusView(),
            Expanded(
              child: SongListView(),
            ),
          ],
        ),
      ),
    );
  }
}
