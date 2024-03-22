import "chansons.dart";

class Artist {
  final String id;
  final String name;
  final int monthlyListeners;
  final List<Chanson> topTracks;
  final String imageUrl;

  Artist({
    required this.id,
    required this.name,
    required this.monthlyListeners,
    required this.topTracks,
    required this.imageUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    List<Chanson> topTracks = json['top_tracks'] != null
        ? (json['top_tracks'] as List).map((trackJson) => Chanson.fromJson(trackJson)).toList()
        : [];

    String imageUrl = '';
    if (json['images'] != null && json['images'].isNotEmpty) {
      imageUrl = json['images'][0]['url'];
    }

    return Artist(
      id: json['id'],
      name: json['name'],
      monthlyListeners: json['monthlyListeners'] ?? 0,
      topTracks: topTracks,
      imageUrl: imageUrl,
    );
  }
}