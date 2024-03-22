import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/providers/api_service.dart';
import '/models/album.dart';
import '/providers/audio_service.dart';
import '/models/chansons.dart';
import 'package:just_audio/just_audio.dart';

class AlbumDetailScreen extends StatelessWidget {
  final String albumId;

  AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService("https://api.spotify.com/v1");

    return Scaffold(
      appBar: AppBar(title: const Text('Album Details')),
      body: FutureBuilder<Album>(
        future: apiService.fetchAlbumDetails(albumId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            final album = snapshot.data!;
            return ListView(
              children: [
                Image.network(
                  album.imageUrl,
                  width: 100, 
                  height: 100,
                ),
                SizedBox(height: 8),
                Text(
                  album.title,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Artistes :', style: Theme.of(context).textTheme.headline6),
                ),
                ...album.artists!.map((artist) => ListTile(
                      title: Text(artist.name),
                      onTap: () => context.go('/a/artistedetails/${artist.id}'),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Chansons :', style: Theme.of(context).textTheme.headline6),
                ),
                ...album.tracks!.map((chanson) => ListTile(
                      title: Text(chanson.name),
                      onTap: () {
                        GlobalAudioPlayer.ajouterChansonALaPlaylist(chanson.previewUrl);
                      },
                    )),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go back'),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}