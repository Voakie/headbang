class Song {
  final int id;
  final String name;
  final String author;
  final int bpm;
  final String source;
  final bool isCustom;

  const Song(
      {required this.id,
      required this.name,
      required this.author,
      required this.bpm,
      required this.source,
      this.isCustom = false});
}
