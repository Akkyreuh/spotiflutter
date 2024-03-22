import "artiste.dart";

class Chanson {
  final String id;
  final String name;
  final String previewUrl;
  final List<Artist> artists;
  final String imageUrl;

  Chanson({
    required this.id,
    required this.name,
    required this.previewUrl,
    required this.artists,
    required this.imageUrl,
  });

  factory Chanson.fromJson(Map<String, dynamic> json) {
    List<Artist> artists = (json['artists'] as List).map((artistJson) => Artist.fromJson(artistJson)).toList();

    String id = json['id'] ?? 'Inconnu'; 
    String name = json['name'] ?? 'Inconnu';
    String previewUrl = json['preview_url'] ?? '';
    String imageUrl = '';

    if (json['album'] != null && json['album']['images'] != null && json['album']['images'].isNotEmpty) {
      imageUrl = json['album']['images'][0]['url'] ?? 'URL_par_défaut';
    }

    return Chanson(
      id: id,
      name: name,
      previewUrl: previewUrl,
      artists: artists,
      imageUrl: imageUrl,
    );
  }
}