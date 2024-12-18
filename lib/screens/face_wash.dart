import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void saveToRoutine(String productName, String routineType) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('routines')
        .add({
          'productName': productName,
          'routineType': routineType, // "Rutinitas Malam" or "Rutinitas Pagi"
          'timestamp': Timestamp.now(),
        });
  }
}

class FaceWash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Perawatan Sabun Cuci Muka'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: productImages.length,
        itemBuilder: (context, index) {
          return ProductCard(
            productImage: productImages[index],
            productName: productNames[index],
            ingredients: productIngredients[index],
            price: productPrices[index],
            productUrl: productUrls[index],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productImage;
  final String productName;
  final String ingredients;
  final String price;
  final String productUrl;

  ProductCard({
    required this.productImage,
    required this.productName,
    required this.ingredients,
    required this.price,
    required this.productUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ProductDetailModal(
            productName: productName,
            productImage: productImage,
            ingredients: ingredients,
            price: price,
            productUrl: productUrl,
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              productImage,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              productName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailModal extends StatelessWidget {
  final String productName;
  final String productImage;
  final String ingredients;
  final String price;
  final String productUrl;

  ProductDetailModal({
    required this.productName,
    required this.productImage,
    required this.ingredients,
    required this.price,
    required this.productUrl,
  });

  void _launchUrl(BuildContext context) async {
    final Uri url = Uri.parse(productUrl);
    if (await canLaunch(productUrl)) {
      await launch(productUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                productImage,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              productName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              ingredients,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              'Price: $price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => RoutineModal(productName: productName),
                    );
                  },
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    'Rutin',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _launchUrl(context),
                  child: Text('Dapatkan produk'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoutineModal extends StatelessWidget {
  final String productName;

  RoutineModal({required this.productName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambah ke Rutin",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            RoutineOption(title: "Rutin Pagi", productName: productName),
            RoutineOption(title: "Rutin Malam", productName: productName),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Batal", style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Selesai"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoutineOption extends StatelessWidget {
  final String title;
  final String productName;

  RoutineOption({required this.title, required this.productName});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        title == "Rutin Pagi" ? Icons.wb_sunny : Icons.nightlight_round,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              saveToRoutine(productName, title);
              Navigator.pop(context); // Close the modal
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$productName has been added to $title')),
              );
            },
            child: Text("+ Tambahkan ke rutin ini"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

// Sample data for products
List<String> productImages = [
  'assets/produk_perawatan/sabun_cuci_muka/Avoskin.png',
  'assets/produk_perawatan/sabun_cuci_muka/Cetaphil.png',
  'assets/produk_perawatan/sabun_cuci_muka/Hada_labo.png',
  'assets/produk_perawatan/sabun_cuci_muka/Originote.png',
];

List<String> productNames = [
  'Avoskin',
  'Cetaphil',
  'Hada Labo',
  'Originote',
];

List<String> productIngredients = [
  'Niacinamide, Panthenol, Vitamin C',
  'Niacinamide, Panthenol, Vitamin B3',
  'Hyaluronic Acid, Vitamin C',
  'Green Tea Extract, Salicylic Acid',
];

List<String> productPrices = [
  'Rp. 100,000',
  'Rp. 130,000',
  'Rp. 120,000',
  'Rp. 115,000',
];

List<String> productUrls = [
  'https://www.tokopedia.com/avoskinofficial/gentle-facial-wash-avoskin-natural-sublime-facial-cleanser-100ml',
  'https://www.tokopedia.com/cetaphil/cetaphil-gentle-skin-cleanser-125ml-sabun-pembersih-muka-untuk-skin-care-cocok-untuk-segala-jenis-kulit',
  'https://tokopedia.com/nihonmart/hada-labo-shirojyun-face-wash-100g',
  'https://www.tokopedia.com/theoriginote/the-originote-cicamide-facial-cleanser-70gr',
];

void main() {
  runApp(MaterialApp(
    home: FaceWash(),
  ));
}
