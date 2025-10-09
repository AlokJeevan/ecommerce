import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  Future<void> addAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final address = _controller.text.trim();
    if (address.isEmpty) return;

    setState(() => _isSaving = true);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
      "address": FieldValue.arrayUnion([address]),
    }, SetOptions(merge: true));

    setState(() => _isSaving = false);

    if (mounted) {
      Navigator.pop(context); // Go back to address list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address added successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter your new address:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "e.g. 123 Main Street, Taipei",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : addAddress,
              icon: const Icon(Icons.save),
              label: Text(_isSaving ? "Saving..." : "Save Address"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
