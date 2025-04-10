import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class InstagramProfilePage extends StatelessWidget {
  const InstagramProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ardamertdedeoglu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Profil Bilgisi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profil Resmi
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const NetworkImage(
                        'https://picsum.photos/200',
                      ),
                    ),
                    const SizedBox(width: 24),
                    // İstatistikler
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Gönderiler', '120'),
                          _buildStatColumn('Takipçiler', '432B'),
                          _buildStatColumn('Takip', '325'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Kullanıcı adı ve bio
                const Text(
                  'Arda Mert Dedeoğlu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bu bir Instagram profil klonu uygulamasıdır. Biyografi bölümü buraya gelecektir. Flutter kullanılarak yapılmıştır.',
                ),
                const SizedBox(height: 12),
                // Düzenle Butonu
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? Colors.white70 : Colors.grey),
                    ),
                    child: Text(
                      'Profili Düzenle',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Hikayeler
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://picsum.photos/200?random=$index',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Hikaye ${index + 1}'),
                    ],
                  ),
                );
              },
            ),
          ),
          // Gönderi Seçenekleri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.grid_on),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.person_pin_outlined),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          // Fotoğraf Gridi
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Image.network(
                'https://picsum.photos/400?random=${index + 10}',
                fit: BoxFit.cover,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
