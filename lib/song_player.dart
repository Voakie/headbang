import 'package:headbang/model/song.dart';
import 'package:just_audio/just_audio.dart';

final songPlayer = SongPlayer();

class SongPlayer {
  final AudioPlayer _player = AudioPlayer();
  Song? _song;

  Future<void> playSong(Song song) async {
    _song = song;

    await _player.setAsset(song.source);
    _player.play();
  }

  Future<void> togglePlaying() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  bool get playing => _player.playing;
  Song? get song => _song;
}
