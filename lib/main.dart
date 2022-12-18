import 'package:flutter/material.dart';
import 'package:headbang/views/esense_status_view.dart';
import 'package:headbang/views/song_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ),
        body: Container(
          child: Column(
            children: const [
              EsenseStatusView(),
              Expanded(
                child: SongListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
