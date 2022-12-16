import 'package:headbang/model/song.dart';
import 'package:just_audio/just_audio.dart';

class SongPlayer {
  final AudioPlayer _player = AudioPlayer();
  Song? _song;
  
  Future<void> playSong(Song song) async {
    _song = song;
    await _player.setUrl(song.source);
    await _player.play();
  }

  Future<void> togglePlaying() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  bool get playing => _player.playing;
  Song? get song => _song;
}