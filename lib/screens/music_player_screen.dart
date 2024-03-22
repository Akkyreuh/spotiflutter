import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer player;
  late ConcatenatingAudioSource playlist;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [
      ],
    );
  
    player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero).catchError((error) {
      print("Erreur lors de la définition de la source audio: $error");
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music Player")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: player.play,
                child: Text("Play"),
              ),
              ElevatedButton(
                onPressed: player.pause,
                child: Text("Pause"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: playlist.children.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Chanson ${index + 1}"),
                  onTap: () {
                    player.seek(Duration.zero, index: index);
                    player.play();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}