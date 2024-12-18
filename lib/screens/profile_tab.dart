import 'package:clearpath/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String name = "";
  String email = "";
  int age = 0;
  String skinType = "";
  String gender = ""; // Added gender field

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userData = await FirestoreService()
            .db.collection('users')
            .doc(user.uid)
            .get();

        // Debugging: print the fetched user data
        print("Fetched user data: ${userData.data()}");

        if (userData.exists) {
          setState(() {
            // Assign values from Firestore document
            name = userData['name'] ?? 'Nama tidak tersedia';
            age = userData['age'] ?? 0;
            skinType = userData['skinType'] ?? 'Tipe kulit tidak tersedia';
            gender = userData['gender'] ?? 'Kelamin tidak tersedia';
          });
        }

        // Use email from FirebaseAuth instance
        email = user.email ?? 'Email tidak tersedia';
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.purple,
                  child: Text(
                    name.isNotEmpty ? name[0] : 'P',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                _buildProfileInfo('Nama', name),
                _buildProfileInfo('Email', email),
                _buildProfileInfo('Umur', age.toString()), // Convert age to string
                _buildProfileInfo('Tipe Kulit', skinType),
                _buildProfileInfo('Kelamin', gender),
                SizedBox(height: 32),
                Divider(),
                _buildSettings(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pengaturan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ListTile(
          leading: Icon(Icons.language),
          title: Text('Bahasa'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text('Aktifkan mode gelap'),
          trailing: Switch(value: false, onChanged: (value) {}),
        ),
        ListTile(
          leading: Icon(Icons.support),
          title: Text('Dukungan'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Tentang'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text('Keluar', style: TextStyle(color: Colors.red)),
          onTap: () {
            // Implement logout function
          },
        ),
      ],
    );
  }
}
