import 'package:clearpath/screens/face_wash.dart';
import 'package:clearpath/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'log_tab.dart';
import 'profile_tab.dart';
import 'night_routine.dart'; // Import NightRoutineScreen
import 'morning_routine.dart'; // Import MorningRoutineScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeTab(),
    LogTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clear Path'),
        backgroundColor: Colors.deepPurple,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// Home Tab content with greeting, scan button, routine, and articles
class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  // Fetch username from Firestore
  Future<void> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirestoreService()
            .db.collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          setState(() {
            userName = userData['name'] ?? 'User';
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hai, $userName',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to AI-based scan screen or call scan function
              // This is where you would add the functionality for skin analysis
            },
            icon: Icon(Icons.camera_alt, color: Colors.white),
            label: Text("Analisis kulitmu sekarang"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Lakukan Rutin Kamu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          _buildRoutineCard("Rutinitas Malam", Icons.nightlight_round),
          SizedBox(height: 8),
          _buildRoutineCard("Rutinitas Pagi", Icons.wb_sunny),
          SizedBox(height: 24),
          Text(
            'Produk Perawatan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 8),
          _buildProductIcons(),
          SizedBox(height: 24),
          Text(
            'Artikel',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          _buildArticleCard(
            "Aktivitas di Rumah untuk Kulit Bersih",
            "Pelajari cara menjaga kulit tetap bersih dan berkilau dengan melakukan...",
            "3 min",
            'https://diricare.com/artikel',
          ),
          SizedBox(height: 8),
          _buildArticleCard(
            "Jerawat tak kunjung sembuh? Yuk",
            "Cari tahu solusi mengatasi jerawat membandel dengan tips perawatan kulit...",
            "5 min",
            'https://www.halodoc.com/artikel/pentingnya-skincare-awareness-di-usia-remaja?srsltid=AfmBOoqtO5BOAqIx-RwzRkeVXe0fNMtiJYOrXKqxTDA6kiEhUyqUIFPl',
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(String title, IconData icon) {
  return Card(
    color: Colors.grey[850],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () {
        // Navigate based on the title of the routine
        if (title == "Rutinitas Malam") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NightRoutine()), // Updated
          );
        } else if (title == "Rutinitas Pagi") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MorningRoutine()), // Updated
          );
        }
      },
    ),
  );
}


  Widget _buildProductIcons() {
    List<Map<String, dynamic>> products = [
      {
        "name": "Sabun Cuci Muka",
        "icon": Icons.clean_hands,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FaceWash()),
          );
        }
      },
      {
        "name": "Pelembab",
        "icon": Icons.emoji_food_beverage,
        "onTap": () {
          // Navigate to product list for Pelembab or show something else
          print("Pelembab tapped");
        }
      },
      {
        "name": "Toner",
        "icon": Icons.bubble_chart,
        "onTap": () {
          // Navigate to product list for Toner or show something else
          print("Toner tapped");
        }
      },
      {
        "name": "Serum",
        "icon": Icons.bubble_chart,
        "onTap": () {
          // Navigate to product list for Serum or show something else
          print("Serum tapped");
        }
      },
      {
        "name": "Tabir Surya",
        "icon": Icons.wb_sunny,
        "onTap": () {
          // Navigate to product list for Tabir Surya or show something else
          print("Tabir Surya tapped");
        }
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: products.map((product) {
        return Column(
          children: [
            GestureDetector(
              onTap: product["onTap"],
              child: Icon(product["icon"], size: 32, color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              product["name"],
              style: TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildArticleCard(String title, String subtitle, String duration, String url) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Container(
          width: 60,
          height: 60,
          color: Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Text(
          duration,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: url),
            ),
          );
        },
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse(widget.url));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
