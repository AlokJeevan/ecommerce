import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _altPhoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  String addressType = 'Home';

  bool _isLoading = false;

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save your address.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final addressData = {
      'fullName': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'altPhone': _altPhoneController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'state': _stateController.text.trim(),
      'city': _cityController.text.trim(),
      'house': _houseController.text.trim(),
      'road': _roadController.text.trim(),
      'landmark': _landmarkController.text.trim(),
      'addressType': addressType,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .add(addressData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Address Saved Successfully")),
      );

      Navigator.pop(context); // Go back to Address list page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error saving address: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Add Address'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Full Name', _nameController),
              _buildTextField('Phone number', _phoneController,
                  keyboardType: TextInputType.phone),
              _buildTextField('Alternate Phone number', _altPhoneController,
                  keyboardType: TextInputType.phone),
              _buildTextField('Pincode', _pincodeController,
                  keyboardType: TextInputType.number),
              Row(
                children: [
                  Expanded(child: _buildTextField('State', _stateController)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField('City', _cityController)),
                ],
              ),
              _buildTextField('House No., Building Name', _houseController),
              _buildTextField('Road name, Area, Colony', _roadController),
              _buildTextField(
                  'Nearby Famous Shop / Landmark', _landmarkController),

              const SizedBox(height: 10),
              const Text(
                'Type of address',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildAddressTypeButton('Home', Icons.home_outlined),
                  const SizedBox(width: 12),
                  _buildAddressTypeButton('Work', Icons.work_outline),
                ],
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Save Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: '$label *',
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black87),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAddressTypeButton(String type, IconData icon) {
    final bool selected = addressType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            addressType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.black : Colors.black26,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : Colors.black54,
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
