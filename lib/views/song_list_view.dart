import 'package:flutter/material.dart';
import 'package:headbang/model/song.dart';
import 'package:headbang/views/song_player_view.dart';

class SongListView extends StatelessWidget {
  final List<Song> song = const [
    Song(
        id: 0,
        name: "Chiquitita",
        author: "ABBA",
        bpm: 84,
        source: "assets/songs/ABBA - Chiquitita-converted.mp3"),
    Song(
        id: 1,
        name: "Still D.R.E.",
        author: "Dr. Dre",
        bpm: 93,
        source:
            "assets/songs/Dr. Dre, Snoop Dogg - Still D.R.E.-converted.mp3"),
    // Song(
    //     id: 10,
    //     name: "Still D.R.E. SHORT",
    //     author: "Dr. Dre",
    //     bpm: 93,
    //     source:
    //         "assets/songs/Dr. Dre, Snoop Dogg - Still D.R.E.-converted-short.mp3"),
    Song(
        id: 2,
        name: "Atemlos durch die Nacht",
        author: "Helene Fischer",
        bpm: 128,
        source:
            "assets/songs/Helene Fischer - Atemlos durch die Nacht-converted.mp3"),
    Song(
        id: 3,
        name: "All I Want for Christmas Is You",
        author: "Mariah Carey",
        bpm: 75,
        source:
            "assets/songs/Mariah Carey - All I Want for Christmas Is You-converted.mp3"),
    Song(
        id: 4,
        name: "Can't Stop",
        author: "Red Hot Chili Peppers",
        bpm: 92,
        source:
            "assets/songs/Red Hot Chili Peppers - Can't Stop-converted.mp3"),
    Song(
        id: 5,
        name: "Dior 2001",
        author: "RIN",
        bpm: 77,
        source: "assets/songs/RIN - Dior 2001-converted.mp3"),
    Song(
        id: 6,
        name: "Last Christmas",
        author: "Wham!",
        bpm: 107,
        source:
            "assets/songs/Wham! - Last Christmas - Remastered-converted.mp3"),
  ];

  const SongListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: song.length,
      itemBuilder: ((context, index) {
        return SongListEntry(song: song[index]);
      }),
    );
  }
}

class SongListEntry extends StatelessWidget {
  const SongListEntry({super.key, required this.song});

  final Song song;

  void playSong(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SongPlayerView(song: song)));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.name),
      subtitle: Text(song.author),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text("${song.bpm.toString()} BPM"),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => playSong(context),
    );
  }
}
