import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screen/profile/paymetMethods.dart';
import 'package:ecommerce/screen/profile/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../auth/signInScreen.dart';
import 'Address.dart';
import 'editProfile.dart';
import 'myOrders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  String userName = "User";
  String userEmail = "No email";
  String userGender = "Male";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        userName = (data['displayname'] ?? 'User').toLowerCase();
        userEmail = data['email'] ?? user.email ?? 'No email';
        userGender = data['gender'] ?? 'unknown';
      });
    } else {
      // fallback if Firestore doc missing
      setState(() {
        userName = (user.displayName ?? 'User').toLowerCase();
        userEmail = user.email ?? 'No email';
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    if (!mounted) return;

    // 🔹 Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.grey.shade100,
        elevation: 0.5,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- User Info Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  // --- Profile Avatar (FontAwesome icon changes based on gender) ---
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    child: FaIcon(
                      userGender == "Male"
                          ? FontAwesomeIcons.person
                          : FontAwesomeIcons.personDress,
                      size: 45,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // --- Name, Email, and Edit Profile ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text("Edit Profile"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black45),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  currentName: userName,
                                  currentGender: userGender,
                                  email: userEmail,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                userName = result['displayname'];
                                userGender = result['gender'];
                              });
                              await _auth.currentUser!
                                  .updateDisplayName(result['name']);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// --- Account Settings ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Account Settings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// --- My Orders ---
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined,
                  color: Colors.black87),
              title: const Text(
                "My Orders",
                style: TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black54),
              onTap: () {
                // 🔹 Navigate to My Orders Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                );
              },
            ),
            const Divider(thickness: 1, color: Colors.black12),

            /// --- Saved Addresses ---
            ListTile(
              leading: const Icon(Icons.location_on_outlined,
                  color: Colors.black87),
              title: const Text(
                "Saved Addresses",
                style: TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black54),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Address()),
                );
              },
            ),
            const Divider(thickness: 1, color: Colors.black12),

            /// --- Payment Methods ---
            ListTile(
              leading: const Icon(Icons.credit_card_outlined,
                  color: Colors.black87),
              title: const Text(
                "Payment Methods",
                style: TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black54),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentMethodsPage()),
                );
              },
            ),
            const Divider(thickness: 1, color: Colors.black12),

            /// --- Wishlist / Favorites ---
            ListTile(
              leading:
              const Icon(Icons.favorite_border, color: Colors.black87),
              title: const Text(
                "Wishlist / Favorites",
                style: TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black54),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistPage()),
                );
              },
            ),
            const Divider(thickness: 1, color: Colors.black12),

            const SizedBox(height: 30),

            /// --- Logout Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.black87, size: 18),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black45),
                  foregroundColor: Colors.black87,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () async {
                  await _logout(context);
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}