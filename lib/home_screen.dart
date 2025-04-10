import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'messages_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'ardamertdedeoglu',
      'userImage': 'https://picsum.photos/200',
      'postImage': 'https://picsum.photos/800/1000?random=1',
      'caption': 'Güzel bir manzara #doğa #huzur',
      'likes': 1243,
      'isLiked': false,
      'isSaved': false,
      'timeAgo': '2 saat önce',
      'location': 'İstanbul, Türkiye'
    },
    {
      'username': 'fotografci',
      'userImage': 'https://picsum.photos/200?random=2',
      'postImage': 'https://picsum.photos/800/600?random=3',
      'caption': 'Bugün harika bir gün #güneş #deniz',
      'likes': 892,
      'isLiked': false,
      'isSaved': false,
      'timeAgo': '5 saat önce',
      'location': 'Bodrum, Muğla'
    },
    {
      'username': 'gezgin',
      'userImage': 'https://picsum.photos/200?random=4',
      'postImage': 'https://picsum.photos/800/800?random=5',
      'caption': 'Yeni maceralara hazırım! #seyahat #gezi',
      'likes': 2547,
      'isLiked': false,
      'isSaved': false,
      'timeAgo': '1 gün önce',
      'location': 'Kapadokya, Nevşehir'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(
          'Instagram',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 30,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Tema Değiştir',
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Navigate to messages screen
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const MessagesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length + 1, // +1 for stories
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildStorySection();
          }
          
          final postIndex = index - 1;
          final post = _posts[postIndex];
          
          return _buildPostItem(post, postIndex);
        },
      ),
    );
  }

  Widget _buildStorySection() {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          bool isMe = index == 0;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.orange, Colors.pink],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://picsum.photos/200?random=${10 + index}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 70,
                  child: Text(
                    isMe ? 'Hikayen' : 'kullanıcı$index',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, int index) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(post['userImage']),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (post['location'] != null)
                        Text(
                          post['location']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
        
        // Post image
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              _posts[index]['isLiked'] = !_posts[index]['isLiked'];
              if (_posts[index]['isLiked']) {
                _posts[index]['likes']++;
              } else {
                _posts[index]['likes']--;
              }
            });
          },
          child: Image.network(
            post['postImage'],
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        
        // Post actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                      color: post['isLiked'] ? Colors.red : (isDark ? Colors.white : Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        _posts[index]['isLiked'] = !_posts[index]['isLiked'];
                        if (_posts[index]['isLiked']) {
                          _posts[index]['likes']++;
                        } else {
                          _posts[index]['likes']--;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _posts[index]['isSaved'] = !_posts[index]['isSaved'];
                  });
                },
              ),
            ],
          ),
        ),
        
        // Likes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${post['likes']} beğenme',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        
        // Caption
        if (post['caption'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                children: [
                  TextSpan(
                    text: '${post['username']} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: post['caption']),
                ],
              ),
            ),
          ),
        
        // Time ago
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            post['timeAgo'],
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ),
        
        const Divider(),
      ],
    );
  }
}
