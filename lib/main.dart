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
        .push(MaterialPageRoute(builder: (context) => ManualView()));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Wähle einen Song"),
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
