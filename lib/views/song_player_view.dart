import 'package:flutter/material.dart';
import 'package:headbang/model/song.dart';
import 'package:headbang/model/song_player.dart';
import 'package:headbang/views/esense_bpm_game.dart';

class SongPlayerView extends StatefulWidget {
  const SongPlayerView({super.key, required this.song});

  final Song song;

  @override
  State<StatefulWidget> createState() => _SongPlayerViewState();
}

class _SongPlayerViewState extends State<SongPlayerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Songplayer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ESenseBPMGame(song: widget.song),
            Text(
              widget.song.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.song.author,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                "${widget.song.bpm.toString()} BPM",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () => togglePlaying(),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child:
                    Icon(songPlayer.playing ? Icons.pause : Icons.play_arrow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startPlaying() async {
    await songPlayer.playSong(widget.song);
    setState(() {});
  }

  void togglePlaying() {
    setState(() {
      songPlayer.togglePlaying();
    });
  }

  @override
  void initState() {
    super.initState();
    startPlaying();
  }

  @override
  void dispose() {
    songPlayer.stop();
    super.dispose();
  }
}
