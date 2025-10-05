import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  Future<void> addAddress(String address) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid) // user-specific document
        .collection("addresses")
        .add({
      "address": address,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<List<String>> getAddresses() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc["address"] as String).toList());
  }


  Future<void> deleteAddress(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .doc(docId)
        .delete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
      ),

    );
  }
}



// void _addAddress(BuildContext context, DocumentReference<Map<String, dynamic>> userDocRef) {
//   final TextEditingController controller = TextEditingController();
//   final List<String> _addresses = []; // Local list for addresses
//   final userId = FirebaseAuth.instance.currentUser?.uid;
//
//
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text("Add New Address"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "Enter your address"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), // Cancel
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final address = controller.text.trim();
//               if (address.isNotEmpty) {
//                 setState(() {
//                   _addresses.add(address);
//                 });
//
//                 // Optional: Save to Firestore
//                 if (userId != null) {
//                   final userDocRef =
//                   FirebaseFirestore.instance.collection('users').doc(userId);
//
//                   // If "address" field is a list
//                   await userDocRef.set({
//                     'address': FieldValue.arrayUnion([address])
//                   }, SetOptions(merge: true));
//                 }
//
//                 Navigator.pop(context); // Close dialog
//               }
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       );
//     },
//   );
//
// }