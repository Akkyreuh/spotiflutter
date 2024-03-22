import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/providers/api_service.dart';
import '/models/album.dart';

class ChansonDetailScreen extends StatelessWidget {
  final String chansonId;

  const ChansonDetailScreen({Key? key, required this.chansonId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la chanson'),
      ),
      body: Center(
        child: Text('Détails pour la chanson ID: $chansonId'),
      ),
    );
  }
}