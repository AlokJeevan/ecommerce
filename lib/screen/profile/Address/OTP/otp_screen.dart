import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🚀 Import this library
import 'package:sms_autofill/sms_autofill.dart';


// 1. Change OtpScreen to a StatefulWidget
class OtpScreen extends StatefulWidget {
  final String verificationId;
  final Function() onVerificationSuccess;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.onVerificationSuccess,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  // 🚀 NEW: Loading state for the verification process
  bool _isVerifying = false;


  void codeUpdated(String code) {
// When SMS arrives, this is automatically triggered
    debugPrint("✅ SMS code received: $code");

    if (code.length == 6) {
      // Auto-fill the 6 boxes
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = code[i];
      }

      // Optionally trigger verification automatically
      _verifyOtp(context, code);
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listenForCode(); // 🔥 Start listening for SMS autofill

  }

  void _listenForCode() async {
    await SmsAutoFill().listenForCode();
    SmsAutoFill().code.listen(codeUpdated); // 👈 pass callback
  }

  // Auto-verify when all 6 digits are entered
  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp(context, _getOtpCode());
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> _verifyOtp(BuildContext context, String otp) async {
    // 1. Basic validation and set loading state
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full 6-digit code")),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      // 2. Create the credential using the verification ID and the OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, // from the previous screen
        smsCode: otp.trim(),
      );

      // 3. Link the phone number credential to the currently signed-in user
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Should not happen if the user is already logged in, but good practice
        throw Exception("User not logged in.");
      }

      await user.linkWithCredential(credential);

      // 4. Success handling
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Phone number verified successfully")),
      );

      // 5. Navigate back and execute the final callback
      Navigator.pop(context); // Pop the OTP screen
      widget.onVerificationSuccess(); // Execute callback to save the address

    } on FirebaseAuthException catch (e) {
      // 6. Error handling for bad code, etc.
      String message = 'Invalid code. Please try again.';
      if (e.code == 'invalid-verification-code') {
        message = 'The entered code is invalid.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Verification Failed: $message")),
      );
    } catch (e) {
      // 7. General error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ An unexpected error occurred: ${e.toString()}")),
      );
    } finally {
      // 8. Reset loading state
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            const Text(
              "Enter the 6-digit code sent to your phone",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return DigitField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) => _onChanged(index, value),
                );
              }),
            ),

            const SizedBox(height: 20),
            // The first TextFormField needs the autofillHints

            // 🚀 REINTRODUCED: Manual Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final code = _getOtpCode();
                  if (code.length == 6) {
                    // Manually trigger verification
                    _verifyOtp(context, code);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter the full 6-digit code")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isVerifying
                    ? const CircularProgressIndicator(color: Colors.white) // Show loader
                    : const Text(
                  'Verify & Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class DigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const DigitField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}