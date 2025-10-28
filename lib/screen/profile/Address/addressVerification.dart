// address_verification_mixin.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import your OtpScreen
import 'OTP/otp_screen.dart';

// Define a contract for the class using this mixin
mixin AddressVerificationState {
  // Required fields and methods from the host State class
  BuildContext get context;
  GlobalKey<FormState> get formKey;
  String? get completePhoneNumber;
  TextEditingController get phoneController;
  void startTimer();
  void stopTimer();
  void setLoader(bool loading);
  Future<void> saveAddress({required bool skipVerification});
}


mixin AddressVerificationMixin<T extends StatefulWidget> on State<T> {
  // Cast the host state to the required contract
  AddressVerificationState get _host => this as AddressVerificationState;

  // Verification State Variables
  int _resendTime = 60;
  Timer? _timer;
  bool _isCodeSent = false;
  final String? _verifiedUserPhone = FirebaseAuth.instance.currentUser?.phoneNumber;

  // --- Timer Methods ---
  void startResendTimer() {
    _isCodeSent = true;
    _resendTime = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime == 0) {
        setState(() {
          _timer?.cancel();
          _isCodeSent = false;
        });
      } else {
        setState(() {
          _resendTime--;
        });
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  // --- Verification Logic ---
  bool isCurrentPhoneVerified() {
    final currentPhone = _host.completePhoneNumber ?? _host.phoneController.text.trim();
    return currentPhone.isNotEmpty && _verifiedUserPhone != null && currentPhone == _verifiedUserPhone;
  }

  Future<void> verifyPhone() async {
    String? phone = _host.completePhoneNumber ?? _host.phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(_host.context).showSnackBar(
        const SnackBar(content: Text("Please enter your phone number")),
      );
      return;
    }

    _host.setLoader(true);

    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.currentUser?.linkWithCredential(credential);
          ScaffoldMessenger.of(_host.context).showSnackBar(
            const SnackBar(content: Text("✅ Phone verified automatically")),
          );
          _host.saveAddress(skipVerification: true);
        },
        verificationFailed: (FirebaseAuthException error) {
          _host.setLoader(false);
          ScaffoldMessenger.of(_host.context).showSnackBar(
            SnackBar(content: Text('❌ Verification failed: ${error.message}')),
          );
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          _host.setLoader(false);
          startResendTimer();

          Navigator.push(
            _host.context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                onVerificationSuccess: () => _host.saveAddress(skipVerification: true),
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _host.setLoader(false);
        },
      );
    } catch (e) {
      _host.setLoader(false);
      ScaffoldMessenger.of(_host.context).showSnackBar(
        const SnackBar(content: Text("❌ Error verifying phone number")),
      );
    }
  }

  // --- UI Data Getters ---
  int get resendTime => _resendTime;
  bool get isCodeSent => _isCodeSent;
}