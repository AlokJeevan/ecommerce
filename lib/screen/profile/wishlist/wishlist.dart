import 'package:flutter/material.dart';
import 'wishlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistService = WishlistService();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Wishlist"),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: wishlistService.wishlistStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final wishlist = snapshot.data?.docs ?? [];

          if (wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text("No items in your wishlist yet",
                      style: TextStyle(color: Colors.black54, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text("Tap the ❤️ icon on a product to add it here.",
                      style: TextStyle(color: Colors.black45, fontSize: 14)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final item = wishlist[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(item['image'], width: 60, height: 60),
                title: Text(item['name']),
                subtitle: Text("\$${item['price']}"),
                trailing: const Icon(Icons.favorite, color: Colors.red),
              );
            },
          );
        },
      ),
    );
  }
}
