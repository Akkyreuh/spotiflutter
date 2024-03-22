import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/providers/api_service.dart';
import '/models/artiste.dart';
import '/models/chansons.dart';

class ArtisteDetailScreen extends StatelessWidget {
  final String artistId;

  ArtisteDetailScreen({Key? key, required this.artistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService("https://api.spotify.com/v1");

    return Scaffold(
      appBar: AppBar(title: const Text('Artiste Details')),
      body: FutureBuilder<Artist>(
        future: apiService.fetchArtistDetails(artistId),
        builder: (context, artistSnapshot) {
          if (artistSnapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (artistSnapshot.hasError) {
            return Center(
                child: Text('Error: ${artistSnapshot.error.toString()}'));
          }
          if (!artistSnapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          final artist = artistSnapshot.data!;
          return ListView(
            children: [
              if (artist.imageUrl.isNotEmpty) 
                Image.network(artist.imageUrl, width: 150, height: 150),
              Text('Nom: ${artist.name}',
                  style: Theme.of(context).textTheme.headline6),
              FutureBuilder<List<Chanson>>(
                future: apiService.fetchArtistTopTracks(artistId),
                builder: (context, tracksSnapshot) {
                  if (!tracksSnapshot.hasData) {
                    return const SizedBox(); 
                  }
                  final tracks = tracksSnapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true, 
                    physics: NeverScrollableScrollPhysics(), 
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return ListTile(
                        leading: Image.network(track.imageUrl, width: 50, height: 50),
                        title: Text(track.name),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}