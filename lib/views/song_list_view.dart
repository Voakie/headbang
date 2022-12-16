import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headbang/model/song.dart';
import 'package:headbang/views/song_player_view.dart';

class SongListView extends StatelessWidget {
  final List<Song> song = [
    Song(name: "Last Christmas", author: "Wham?", bpm: 0, source: "lol"),
    Song(name: "Still Dre", author: "Snop Doog", bpm: 0, source: "lol"),
    Song(name: "Atemlos", author: "Helene Melene", bpm: 0, source: "lol"),
    Song(name: "a", author: "author", bpm: 0, source: "lol"),
    Song(name: "b", author: "author", bpm: 0, source: "lol")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: song.length,
          itemBuilder: ((context, index) {
            return SongListEntry(song: song[index]);
          }),
        ));
  }
}

class SongListEntry extends StatelessWidget {
  SongListEntry({super.key, required this.song});

  Song song;

  void playSong(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SongPlayerView())
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.name),
      subtitle: Text(song.author),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => playSong(context),
    );
  }
}
