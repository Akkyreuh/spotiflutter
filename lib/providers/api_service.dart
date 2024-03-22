import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/album.dart';
import '/models/artiste.dart';
import '/models/chansons.dart';

class ApiService {
  final String _baseUrl;
  String? _accessToken;

  ApiService(this._baseUrl) {
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    _accessToken = "BQBALkU8tmm7dFR3gOC2mdEZpG06N98iip2neDb0KGcVccDXY7_Mm2OUmiv9BjMQi1IAeb31fodn4oVv63D3sakr6OirWQWRMRvJbNCQqLEO7hJN4xQ"; // Utilisez un token valide ici
  }

  Future<List<Album>> fetchNewReleases() async {
    final response = await fetchData('browse/new-releases');
    final parsedJson = jsonDecode(response);
    final albumsJson = parsedJson['albums']['items'] as List;

    return albumsJson.map((json) => Album.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Album> fetchAlbumDetails(String albumId) async {
    final response = await fetchData('albums/$albumId');
    final parsedJson = jsonDecode(response);
    return Album.fromJson(parsedJson);
  }

  Future<Artist> fetchArtistDetails(String artistId) async {
    final response = await fetchData('artists/$artistId');
    final parsedJson = jsonDecode(response);
    return Artist.fromJson(parsedJson);
  }

Future<Chanson> fetchSongDetails(String songId) async {

  var response = await http.get(Uri.parse('https://api.spotify.com/v1/tracks/$songId'), headers: {
  });

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return Chanson.fromJson(data);
  } else {
    throw Exception('Failed to load song details');
  }
}

  Future<List<Chanson>> fetchArtistTopTracks(String artistId) async {
    final response = await fetchData('artists/$artistId/top-tracks?market=US');
    final parsedJson = jsonDecode(response);

    if (parsedJson['tracks'] != null) {
      final tracksJson = parsedJson['tracks'] as List;
      return tracksJson.map((json) => Chanson.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Album>> searchAlbums(String query) async {
    final response = await fetchData('search?type=album&market=FR&q=$query');
    final parsedJson = jsonDecode(response);

    if (parsedJson['albums'] != null && parsedJson['albums']['items'] != null) {
      final albumsJson = parsedJson['albums']['items'] as List;
      return albumsJson.map((json) => Album.fromJson(json)).toList();
    } else {
      return [];
    }
  }
  
  Future<List<Chanson>> searchTracks(String query) async {
    final response = await fetchData('search?type=track&market=FR&q=$query');
    final parsedJson = jsonDecode(response);

    if (parsedJson['tracks'] != null && parsedJson['tracks']['items'] != null) {
      final tracksJson = parsedJson['tracks']['items'] as List;
      return tracksJson.map((json) => Chanson.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Artist>> searchArtists(String query) async {
    final response = await fetchData('search?type=artist&market=FR&q=$query');
    final parsedJson = jsonDecode(response);

    if (parsedJson['artists'] != null && parsedJson['artists']['items'] != null) {
      final artistsJson = parsedJson['artists']['items'] as List;
      return artistsJson.map((json) => Artist.fromJson(json)).toList();
    } else {
      return [];
    }
  }




  Future<String> fetchData(String endpoint) async {
    if (_accessToken == null) {
      await _fetchToken();
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data from API: ${response.statusCode}');
    }
  }
}