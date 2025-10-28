import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.grey.shade100,
        elevation: 0.5,
        centerTitle: true,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Last updated: October 2025",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // --- Introduction ---
            Text(
              "At Shoepify, your privacy is our top priority. This Privacy Policy explains how we collect, use, and protect your information when you use our app and services.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // --- Section 1: Information We Collect ---
            const Text(
              "1. Information We Collect",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We collect the following types of information to improve your experience:",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint("Personal details (name, email, phone number)."),
            _buildBulletPoint("Account credentials used to sign in."),
            _buildBulletPoint("Order history, wishlist items, and saved addresses."),
            _buildBulletPoint("Device and app usage data to enhance app performance."),
            const SizedBox(height: 24),

            // --- Section 2: How We Use Your Information ---
            const Text(
              "2. How We Use Your Information",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint("To process your orders and manage your account."),
            _buildBulletPoint("To improve user experience and app functionality."),
            _buildBulletPoint("To send updates, offers, and promotional notifications."),
            _buildBulletPoint("To maintain security and prevent fraudulent activity."),
            const SizedBox(height: 24),

            // --- Section 3: Data Security ---
            const Text(
              "3. Data Security",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We use advanced encryption and authentication measures to protect your personal data. However, please note that no method of online data transmission is 100% secure.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // --- Section 4: Sharing of Information ---
            const Text(
              "4. Sharing of Information",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We do not sell or rent your personal data. Information is shared only with trusted partners such as payment gateways and delivery services, and only as needed to fulfill your orders.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // --- Section 5: Your Rights ---
            const Text(
              "5. Your Rights",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint("You can access and update your personal details anytime."),
            _buildBulletPoint("You may request deletion of your account data."),
            _buildBulletPoint("You can opt out of promotional communications."),
            const SizedBox(height: 24),

            // --- Section 6: Contact Us ---
            const Text(
              "6. Contact Us",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "If you have any questions about this Privacy Policy, please contact us at:",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  "privacy@shoepify.com",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- Footer ---
            Center(
              child: Text(
                "© 2025 Shoepify. All rights reserved.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for bullet point text
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 15, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
