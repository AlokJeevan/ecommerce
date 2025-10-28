import 'package:flutter/material.dart';

// Helper function signature for consistency
typedef AddressTypeCallback = void Function(String type);

// --- 1. Form Field Builder ---
Widget buildTextField(
    String label,
    TextEditingController controller, {
      bool required = true,
      TextInputType keyboardType = TextInputType.text,
      int? maxLength,
      String? Function(String?)? validator,
      required BuildContext context,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14.0),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator ??
              (value) {
            if (required && (value == null || value.isEmpty)) {
              return 'Please enter your $label';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black26),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black87),
        ),
        labelStyle: const TextStyle(color: Colors.black54),
      ),
    ),
  );
}


// --- 2. Address Type Button Builder ---
Widget buildAddressTypeButton(String type, IconData icon, String currentType, AddressTypeCallback onTap) {
  final bool selected = currentType == type;
  return Expanded(
    child: GestureDetector(
      onTap: () => onTap(type),
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

// --- 3. Conditional Verification Widget ---
Widget buildVerificationWidget({
  required bool isCurrentPhoneVerified,
  required bool isLoading,
  required bool isCodeSent,
  required int resendTime,
  required VoidCallback onPressed,
}) {
  if (isCurrentPhoneVerified) {
    // Case 1: Phone is verified (show badge)
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade400),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          Text(
            'Verified',
            style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  } else {
    // Case 2: Phone is NOT verified (show Verify/Resend button)
    return SizedBox(
      height: 58,
      child: Align(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: (isLoading || (isCodeSent && resendTime > 0)) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : Text(
            isCodeSent && resendTime > 0
                ? 'Resend ($resendTime s)'
                : isCodeSent ? 'Resend' : 'Verify',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}