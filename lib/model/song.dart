class Song {
  final int id = DateTime.now().millisecondsSinceEpoch;
  final String name;
  final String author;
  final int bpm;
  final String source;

  Song(
      {required this.name,
      required this.author,
      required this.bpm,
      required this.source});
}