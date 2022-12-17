import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headbang/model/song.dart';
import 'package:headbang/views/song_player_view.dart';

class SongListView extends StatelessWidget {
  final List<Song> song = [
    Song(
        name: "Chiquitita",
        author: "ABBA",
        bpm: 0,
        source: "assets/songs/ABBA - Chiquitita-converted.mp3"),
    Song(
        name: "Still D.R.E.",
        author: "Dr. Dre",
        bpm: 0,
        source:
            "assets/songs/Dr. Dre, Snoop Dogg - Still D.R.E.-converted.mp3"),
    Song(
        name: "Atemlos durch die Nacht",
        author: "Helene Fischer",
        bpm: 0,
        source:
            "assets/songs/Helene Fischer - Atemlos durch die Nacht-converted.mp3"),
    Song(
        name: "All I Want for Christmas Is You",
        author: "Mariah Carey",
        bpm: 0,
        source:
            "assets/songs/Mariah Carey - All I Want for Christmas Is You-converted.mp3"),
    Song(
        name: "Can't Stop",
        author: "Red Hot Chili Peppers",
        bpm: 0,
        source:
            "assets/songs/Red Hot Chili Peppers - Can't Stop-converted.mp3"),
    Song(
        name: "Dior 2001",
        author: "RIN",
        bpm: 0,
        source: "assets/songs/RIN - Dior 2001-converted.mp3"),
    Song(
        name: "Last Christmas",
        author: "Wham!",
        bpm: 0,
        source:
            "assets/songs/Wham! - Last Christmas - Remastered-converted.mp3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: song.length,
        itemBuilder: ((context, index) {
          return SongListEntry(song: song[index]);
        }),
      ),
    );
  }
}

class SongListEntry extends StatelessWidget {
  SongListEntry({super.key, required this.song});

  Song song;

  void playSong(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SongPlayerView(song: song)));
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
