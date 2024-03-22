import 'artiste.dart';
import 'chansons.dart'; // Assurez-vous que l'importation est correcte

class Album {
  final String id;
  final String title;
  final String imageUrl;
  final List<Artist>? artists;
  final List<Chanson>? tracks; // Utilisez la classe Chanson

  Album({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.artists,
    this.tracks, // Modification ici pour accepter une liste de Chanson
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    List<Artist>? artists = json['artists'] != null
        ? (json['artists'] as List).map((artistJson) => Artist.fromJson(artistJson)).toList()
        : null;


    List<Chanson>? tracks = json['tracks'] != null && json['tracks']['items'] != null
        ? (json['tracks']['items'] as List).map((trackJson) => Chanson.fromJson(trackJson)).toList()
        : null;

    return Album(
      id: json['id'],
      title: json['name'],
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : 'https://via.placeholder.com/150',
      artists: artists,
      tracks: tracks,
    );
  }
}