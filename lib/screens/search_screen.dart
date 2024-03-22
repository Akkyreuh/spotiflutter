import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/providers/api_service.dart';
import '/models/album.dart';
import '/models/chansons.dart';
import '/models/artiste.dart';

enum SearchType { album, chanson, chanteur }

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  SearchType _selectedSearchType = SearchType.album;
  List<dynamic> _searchResults = [];

  Future<void> _search(String query) async {
    final apiService = ApiService("https://api.spotify.com/v1");
    if (query.isNotEmpty) {
      switch (_selectedSearchType) {
        case SearchType.album:
          final results = await apiService.searchAlbums(query);
          setState(() {
            _searchResults = results;
          });
          break;
        case SearchType.chanson:
          final results = await apiService.searchTracks(query);
          setState(() {
            _searchResults = results;
          });
          break;
        case SearchType.chanteur:
          final results = await apiService.searchArtists(query);
          setState(() {
            _searchResults = results;
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Screen')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _searchResults = [];
                    });
                  },
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: SearchType.values.map((type) {
              return ChoiceChip(
                label: Text(type.toString().split('.').last),
                selected: _selectedSearchType == type,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedSearchType = type;
                  });
                },
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () => _search(_controller.text),
            child: const Text('Recherche'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                String title = '';
                String? imageUrl;
                VoidCallback? onTap;

                if (result is Album) {
                  title = result.title;
                  imageUrl = result.imageUrl;
                  onTap = () => context.go('/a/albumdetails/${result.id}');
                } else if (result is Chanson) {
                  title = result.name;
                  imageUrl = result.imageUrl;
                  onTap = () => context.go('/a/chansondetails/${result.id}');
                } else if (result is Artist) {
                  title = result.name;
                  imageUrl =result.imageUrl;
                      null;
                  onTap = () => context.go('/a/artistedetails/${result.id}');
                }

                return ListTile(
                  title: Text(title),
                  leading: imageUrl != null
                      ? Image.network(imageUrl, width: 50, height: 50)
                      : null,
                  onTap: onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
