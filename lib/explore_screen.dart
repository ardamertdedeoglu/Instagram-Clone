import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Ara...',
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _isSearching = false;
                        _searchQuery = "";
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _isSearching = value.isNotEmpty;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Tema Değiştir',
          ),
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildExploreGrid(),
    );
  }
  
  Widget _buildSearchResults() {
    // Eğer arama kelimesi kullanıcı adını içeriyorsa, kullanıcı profili göster
    if (_searchQuery.toLowerCase().contains('arda') || 
        _searchQuery.toLowerCase().contains('mert') ||
        _searchQuery.toLowerCase().contains('dedeoglu') ||
        _searchQuery.toLowerCase().contains('ardamertdedeoglu')) {
      return ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://picsum.photos/200'),
        ),
        title: const Text('ardamertdedeoglu'),
        subtitle: const Text('Arda Mert Dedeoğlu'),
        trailing: const Icon(Icons.verified),
        onTap: () {
          // Navigate to profile using Navigator
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InstagramProfilePage()),
          );
          // Alternatively, if using a bottom navigation bar in parent widget:
          // Navigator.of(context).pop(); // Close the search results
          // You can also use a callback function passed from parent to change tabs
        },
      );
    }
    
    // Başka sonuç yoksa, bu mesajı göster
    return const Center(
      child: Text('Aradığınız kullanıcı bulunamadı.'),
    );
  }
  
  Widget _buildExploreGrid() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(3),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Random image heights for visual variety
                final heights = [200, 250, 300, 350, 400];
                final randomHeight = heights[index % heights.length];
                
                return InkWell(
                  onTap: () {
                    // Show a simple modal when tapping on an image
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://picsum.photos/400/$randomHeight?random=${index + 100}',
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 16),
                              const Text('Keşfet gönderisi'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Kapat'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    'https://picsum.photos/400/$randomHeight?random=${index + 100}',
                    fit: BoxFit.cover,
                  ),
                );
              },
              childCount: 30, // 30 random images
            ),
          ),
        ),
      ],
    );
  }
}
