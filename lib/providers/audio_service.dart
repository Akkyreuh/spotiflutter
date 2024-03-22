// audio_service.dart
import 'package:just_audio/just_audio.dart';

class GlobalAudioPlayer {
  static final AudioPlayer player = AudioPlayer();
  static final ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
  );

  static Future<void> initialize() async {
    await player.setAudioSource(playlist);
  }

    static void ajouterChansonALaPlaylist(String previewUrl) async {
    try {
      if (previewUrl.isNotEmpty) {
        print("Ajout de la chanson à la playlist : $previewUrl");
        await playlist.add(AudioSource.uri(Uri.parse(previewUrl)));
        await player.setAudioSource(playlist); // Reconfigurer la source audio pour inclure la nouvelle playlist
        await player.play();
        print("Lecture de la chanson.");
      } else {
        print("URL de la chanson est vide ou non valide.");
      }
    } catch (e) {
      print("Erreur lors de l'ajout de la chanson à la playlist : $e");
    }
  }
}