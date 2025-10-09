import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addAddress.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {

  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    Future<void> _editAddress(
        BuildContext context, String oldAddress, DocumentReference userDocRef) async {
      final controller = TextEditingController(text: oldAddress);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Edit Address"),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Enter new address",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newAddress = controller.text.trim();
                if (newAddress.isEmpty) return;

                // 1️⃣ Remove old address
                await userDocRef.update({
                  'address': FieldValue.arrayRemove([oldAddress])
                });

                // 2️⃣ Add new address
                await userDocRef.update({
                  'address': FieldValue.arrayUnion([newAddress])
                });

                // Close dialog
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Address updated successfully")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Addresses"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAddress()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDocRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null || userData['address'] == null) {
            return const Center(
              child: Text("Your saved addresses will show here"),
            );
          }

          List addresses = List.from(userData['address']);

          if (addresses.isEmpty) {
            return const Center(
              child: Text("Your saved addresses will show here"),
            );
          }

          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.home),
                title: Text(addresses[index]),
                onTap: () => _editAddress(context, addresses[index], userDocRef),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Remove from Firestore
                    await userDocRef.update({
                      'address': FieldValue.arrayRemove([addresses[index]])
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }










}