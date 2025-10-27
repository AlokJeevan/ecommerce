import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String? currentName;
  final String? currentGender;
  final String? email;

  const EditProfilePage({
    Key? key,
    this.currentName,
    this.currentGender,
    this.email,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  String userName = '';
  String userGender = '';
  String userEmail = '';

  final TextEditingController _nameController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      final data = docSnap.data()!;

      // ✅ Ensure gender field exists
      if (!data.containsKey('gender')) {
        await docRef.update({'gender': 'unknown'});
        data['gender'] = 'unknown';
      }

      setState(() {
        userName = data['displayname'] ?? 'Unknown';
        userGender = data['gender'] ?? 'unknown';
        userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

        _nameController.text = userName;
        _selectedGender = userGender;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'displayname': _nameController.text.trim(),
      'gender': _selectedGender ?? 'unknown',
    });

    Navigator.pop(context, {
      'displayname': _nameController.text.trim(),
      'gender': _selectedGender ?? 'unknown',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// --- Avatar Section (based on gender) ---
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                _selectedGender == "Female"
                    ? Icons.female_rounded
                    : Icons.person_outline,
                size: 60,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            /// --- Email Display (Non Editable) ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: Colors.black54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      userEmail.isNotEmpty ? userEmail : 'Loading...',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// --- Name Field ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// --- Gender Selection ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.wc_outlined),
                  labelText: "Gender",
                ),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                  DropdownMenuItem(
                      value: "unknown", child: Text("Prefer not to say")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            /// --- Save Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_outlined),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}