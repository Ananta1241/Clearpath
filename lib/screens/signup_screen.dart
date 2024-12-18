import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clearpath/services/firestore_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSkinType;
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lengkapi Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama kamu', style: TextStyle(fontSize: 18)),
            TextField(controller: _nameController),
            SizedBox(height: 20),

            Text('Email', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            Text('Password', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 20),

            Text('Tipe kulit kamu', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Kering', 'Berminyak', 'Sensitif']
                  .map((type) => ChoiceChip(
                        label: Text(type),
                        selected: _selectedSkinType == type,
                        onSelected: (selected) {
                          setState(() {
                            _selectedSkinType = type;
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),

            Text('Usia kamu', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            Text('Jenis Kelamin kamu', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Radio<String>(
                  value: 'Laki-laki',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Laki-laki'),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                Text('Perempuan'),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await _registerUser();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      // Register with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
          );

      // Save user profile to Firestore
      await FirestoreService().saveUserProfile(
        userId: userCredential.user?.uid,
        name: _nameController.text,
        skinType: _selectedSkinType,
        age: int.tryParse(_ageController.text),
        gender: _selectedGender,
      );

      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    }
  }
}
