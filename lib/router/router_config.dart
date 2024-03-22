import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/screens/album_detail_screen.dart';
import 'package:projet_spotify_gorouter/screens/album_news_screen.dart';
import 'package:projet_spotify_gorouter/screens/artiste_detail_screen.dart';
import 'package:projet_spotify_gorouter/screens/chanson_detail_screen.dart'; // Assurez-vous d'importer la nouvelle page de détails de la chanson
import 'package:projet_spotify_gorouter/screens/playlist_screen.dart';
import 'package:projet_spotify_gorouter/screens/search_screen.dart';
import 'package:projet_spotify_gorouter/scaffold_with_navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

final GoRouter router = GoRouter(
  initialLocation: '/a',
  navigatorKey: _rootNavigatorKey,
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: const Scaffold(
      body: Center(
        child: Text('Page introuvable'),
      ),
    ),
  ),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
              path: '/a',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AlbumNewsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'albumdetails/:id',
                  builder: (BuildContext context, GoRouterState state) {
                    final String albumId = state.pathParameters['id']!;
                    return AlbumDetailScreen(albumId: albumId);
                  },
                ),
                GoRoute(
                  path: 'artistedetails/:artistId',
                  builder: (BuildContext context, GoRouterState state) {
                    final artistId = state.pathParameters['artistId']!;
                    return ArtisteDetailScreen(artistId: artistId);
                  },
                ),
                // Nouvelle route pour les détails de la chanson
                GoRoute(
                  path: 'chansondetails/:chansonId',
                  builder: (BuildContext context, GoRouterState state) {
                    final chansonId = state.pathParameters['chansonId']!;
                    return ChansonDetailScreen(chansonId: chansonId);
                  },
                ),
              ],
            ),
          ],
        ),
        // D'autres branches pour d'autres sections de l'application peuvent être ajoutées ici
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              path: '/b',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchScreen(),
              ),
              // Ajoutez ici des routes enfants si nécessaire
            ),
          ],
        ),
        // Ajoutez plus de branches si nécessaire
      ],
    ),
  ],
);