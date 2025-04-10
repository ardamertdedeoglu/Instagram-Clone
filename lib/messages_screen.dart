import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _chats = [
    {
      'userId': 1,
      'username': 'fotografci',
      'userImage': 'https://picsum.photos/200?random=2',
      'lastMessage': 'Fotoğrafını çok beğendim!',
      'time': '2d',
      'isUnread': true,
      'isOnline': true,
    },
    {
      'userId': 2,
      'username': 'gezgin',
      'userImage': 'https://picsum.photos/200?random=4',
      'lastMessage': 'Yarın buluşalım mı?',
      'time': '1s',
      'isUnread': true,
      'isOnline': false,
    },
    {
      'userId': 3,
      'username': 'tasarimci',
      'userImage': 'https://picsum.photos/200?random=6',
      'lastMessage': 'Proje hazır, gönderiyorum',
      'time': '3s',
      'isUnread': false,
      'isOnline': true,
    },
    {
      'userId': 4,
      'username': 'yazilimci',
      'userImage': 'https://picsum.photos/200?random=8',
      'lastMessage': 'Bu yeni uygulamayı denedin mi?',
      'time': '1g',
      'isUnread': false,
      'isOnline': false,
    },
    {
      'userId': 5,
      'username': 'sporsever',
      'userImage': 'https://picsum.photos/200?random=10',
      'lastMessage': 'Maç saat kaçta başlıyor?',
      'time': '16s',
      'isUnread': true,
      'isOnline': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredChats {
    if (_searchQuery.isEmpty) {
      return _chats;
    }
    return _chats.where((chat) {
      final username = chat['username'].toString().toLowerCase();
      final lastMessage = chat['lastMessage'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      
      return username.contains(query) || lastMessage.contains(query);
    }).toList();
  }

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
        title: Row(
          children: [
            Text(
              'ardamertdedeoglu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
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
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ara',
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Search results or empty state
          if (_searchQuery.isNotEmpty && _filteredChats.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '"$_searchQuery" ile ilgili sonuç bulunamadı',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Chat list
          if (_filteredChats.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = _filteredChats[index];
                  return _buildChatItem(chat, context);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    // Highlight the search term if present
    Widget messageText;
    if (_searchQuery.isNotEmpty) {
      final lastMessage = chat['lastMessage'].toString();
      final query = _searchQuery.toLowerCase();
      
      if (lastMessage.toLowerCase().contains(query)) {
        final startIndex = lastMessage.toLowerCase().indexOf(query);
        final endIndex = startIndex + query.length;
        
        messageText = RichText(
          text: TextSpan(
            style: TextStyle(
              color: chat['isUnread'] 
                  ? (isDark ? Colors.white : Colors.black) 
                  : Colors.grey[500],
              fontWeight: chat['isUnread'] 
                  ? FontWeight.bold 
                  : FontWeight.normal,
            ),
            children: [
              TextSpan(text: lastMessage.substring(0, startIndex)),
              TextSpan(
                text: lastMessage.substring(startIndex, endIndex),
                style: TextStyle(
                  backgroundColor: Colors.yellow[700],
                  color: Colors.black,
                ),
              ),
              TextSpan(text: lastMessage.substring(endIndex)),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      } else {
        messageText = Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: chat['isUnread'] 
                ? (isDark ? Colors.white : Colors.black) 
                : Colors.grey[500],
            fontWeight: chat['isUnread'] 
                ? FontWeight.bold 
                : FontWeight.normal,
          ),
        );
      }
    } else {
      messageText = Text(
        chat['lastMessage'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: chat['isUnread'] 
              ? (isDark ? Colors.white : Colors.black) 
              : Colors.grey[500],
          fontWeight: chat['isUnread'] 
              ? FontWeight.bold 
              : FontWeight.normal,
        ),
      );
    }
    
    // Highlight username if it matches search query
    Widget usernameText;
    if (_searchQuery.isNotEmpty && 
        chat['username'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) {
      final username = chat['username'].toString();
      final query = _searchQuery.toLowerCase();
      final startIndex = username.toLowerCase().indexOf(query);
      final endIndex = startIndex + query.length;
      
      usernameText = RichText(
        text: TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: username.substring(0, startIndex)),
            TextSpan(
              text: username.substring(startIndex, endIndex),
              style: TextStyle(
                backgroundColor: Colors.yellow[700],
                color: Colors.black,
              ),
            ),
            TextSpan(text: username.substring(endIndex)),
          ],
        ),
      );
    } else {
      usernameText = Text(
        chat['username'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chat: chat),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // User image with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chat['userImage']),
                ),
                if (chat['isOnline'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.black : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Message info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  usernameText,
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: messageText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chat['time'],
                        style: TextStyle(
                          color: chat['isUnread'] 
                              ? Colors.blue 
                              : Colors.grey[500],
                          fontSize: 12,
                          fontWeight: chat['isUnread'] 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Camera icon
            IconButton(
              icon: Icon(
                Icons.camera_alt_outlined,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    // Populate with some dummy messages
    _messages.addAll([
      {
        'text': 'Merhaba!',
        'isMe': false,
        'time': '14:30',
      },
      {
        'text': 'Selam, nasılsın?',
        'isMe': true,
        'time': '14:31',
      },
      {
        'text': 'İyiyim, teşekkürler. Sen nasılsın?',
        'isMe': false,
        'time': '14:32',
      },
      {
        'text': 'Ben de iyiyim. Bugün ne yapıyorsun?',
        'isMe': true,
        'time': '14:33',
      },
      {
        'text': 'Biraz çalışıyorum, sonra arkadaşlarla buluşacağım. Sen?',
        'isMe': false,
        'time': '14:35',
      },
    ]);
    
    // If this user had unread messages, mark them as read
    if (widget.chat['isUnread']) {
      widget.chat['isUnread'] = false;
    }
    
    // Scroll to bottom after the layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': '${DateTime.now().hour}:${DateTime.now().minute}',
        });
        _messageController.clear();
      });
      
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.chat['userImage']),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.chat['isOnline'] ? 'Çevrimiçi' : 'Çevrimdışı',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.chat['isOnline'] ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message, isDark);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesaj...',
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.mic),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, bool isDark) {
    return Align(
      alignment: message['isMe'] 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          top: 4,
          bottom: 4,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message['isMe']
              ? Colors.blue
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: message['isMe'] ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message['time'],
              style: TextStyle(
                fontSize: 10,
                color: message['isMe'] 
                    ? Colors.white70 
                    : Colors.grey[500],
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
