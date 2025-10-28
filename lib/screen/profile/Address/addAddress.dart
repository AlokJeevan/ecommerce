import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

// 🚀 Imports from split files
import 'addressFormWidget.dart';
import 'addressVerification.dart';

class AddAddressPage extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? existingData;
  const AddAddressPage({super.key, this.docId, this.existingData});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage>
    with AddressVerificationMixin<AddAddressPage>
    implements AddressVerificationState {
  // --- 1. State Variables ---
  final _formKey = GlobalKey<FormState>();
  String? _completePhoneNumber;

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

  // --- 2. Mixin requirements ---
  @override
  GlobalKey<FormState> get formKey => _formKey;
  @override
  String? get completePhoneNumber => _completePhoneNumber;
  @override
  TextEditingController get phoneController => _phoneController;
  @override
  void setLoader(bool loading) => setState(() => _isLoading = loading);
  @override
  void startTimer() => startResendTimer();
  @override
  void stopTimer() => cancelTimer();

  // --- 3. Lifecycle ---
  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final data = widget.existingData!;
      _nameController.text = data['fullName'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _altPhoneController.text = data['altPhone'] ?? '';
      _pincodeController.text = data['pincode'] ?? '';
      _stateController.text = data['state'] ?? '';
      _cityController.text = data['city'] ?? '';
      _houseController.text = data['house'] ?? '';
      _roadController.text = data['road'] ?? '';
      _landmarkController.text = data['landmark'] ?? '';
      addressType = data['addressType'] ?? 'Home';
    }
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  // --- 4. Save Logic ---
  @override
  Future<void> saveAddress({bool skipVerification = false}) async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save your address.")),
      );
      return;
    }

    if (!skipVerification &&
        (user.phoneNumber == null || user.phoneNumber!.isEmpty)) {
      await verifyPhone();
      return;
    }

    setState(() => _isLoading = true);

    final addressData = {
      'fullName': _nameController.text.trim(),
      'phone': _completePhoneNumber ?? _phoneController.text.trim(),
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
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses');

      if (widget.docId != null) {
        await ref.doc(widget.docId).update(addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✏️ Address Updated Successfully")),
        );
      } else {
        await ref.add(addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Address Added Successfully")),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error saving address: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- 5. Build Method ---
  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.docId != null;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Address' : 'Add Address'),
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
              buildTextField('Full Name', _nameController, context: context),

              /// ✅ Phone field with 10-digit validation
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: IntlPhoneField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number *',
                            labelStyle: TextStyle(color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            counterText: "",
                          ),
                          initialCountryCode: 'IN',
                          keyboardType: TextInputType.phone,
                          onChanged: (phone) {
                            _completePhoneNumber = phone.completeNumber;
                            if (!isCurrentPhoneVerified()) {
                              setState(() {
                                cancelTimer();
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.number.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.number.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    buildVerificationWidget(
                      isCurrentPhoneVerified: isCurrentPhoneVerified(),
                      isLoading: _isLoading,
                      isCodeSent: isCodeSent,
                      resendTime: resendTime,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          verifyPhone();
                        }
                      },
                    ),
                  ],
                ),
              ),

              /// ✅ Alternate phone validation (optional 10 digits)
              buildTextField(
                'Alternate Phone number',
                _altPhoneController,
                keyboardType: TextInputType.phone,
                required: false,
                maxLength: 10,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length != 10) {
                    return 'Must be 10 digits';
                  }
                  return null;
                },
                context: context,
              ),

              /// ✅ Pincode validation (6 digits)
              buildTextField(
                'Pincode',
                _pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  } else if (value.length != 6) {
                    return 'Pincode must be 6 digits';
                  }
                  return null;
                },
                context: context,
              ),

              Row(
                children: [
                  Expanded(
                      child: buildTextField('State', _stateController,
                          context: context)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: buildTextField(
                          'City', _cityController, context: context)),
                ],
              ),
              buildTextField('House No., Building Name', _houseController,
                  context: context),
              buildTextField(
                  'Road name, Area, Colony', _roadController, context: context),
              buildTextField('Nearby Famous Shop / Landmark',
                  _landmarkController, context: context),

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
                  buildAddressTypeButton('Home', Icons.home_outlined,
                      addressType, (type) => setState(() => addressType = type)),
                  const SizedBox(width: 12),
                  buildAddressTypeButton('Work', Icons.work_outline, addressType,
                          (type) => setState(() => addressType = type)),
                ],
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    isEditMode ? 'Update Address' : 'Save Address',
                    style: const TextStyle(
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
}
