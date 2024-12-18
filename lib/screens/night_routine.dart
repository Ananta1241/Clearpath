import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NightRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rutin Malam 🌙'),
      ),
      body: user != null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('routines')
                  .where('routineType', isEqualTo: 'Rutin Malam')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No routines added yet."));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['productName']),
                      subtitle: Text('Routine: ${data['routineType']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('routines')
                              .doc(doc.id)
                              .delete();
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            )
          : Center(child: Text("Please log in to view routines")),
    );
  }
}
