import 'package:ecommerce/screen/profile/myOrders.dart';
import 'package:ecommerce/screen/profile/paymetMethods.dart';
import 'package:ecommerce/screen/profile/wishlist.dart';
import 'package:flutter/material.dart';
import 'Address/Address.dart';
import 'editProfile.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Help Center"),
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
            const Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Find answers to frequently asked questions or contact our support team for further assistance.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),

            // --- Common Topics ---
            const Text(
              "Common Topics",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildHelpTile(
              context,
              icon: Icons.shopping_bag_outlined,
              title: "Order & Delivery",
              subtitle: "Track orders, delivery issues, or returns.",
              destination: const MyOrdersPage(),
            ),
            _buildHelpTile(
              context,
              icon: Icons.payment_outlined,
              title: "Payments & Refunds",
              subtitle: "Manage payments, refunds, and wallet balance.",
              destination: const PaymentMethodsPage(),
            ),
            _buildHelpTile(
              context,
              icon: Icons.person_outline,
              title: "Account & Profile",
              subtitle: "Update your personal information or password.",
              destination: const EditProfilePage(),
            ),
            _buildHelpTile(
              context,
              icon: Icons.favorite_outline,
              title: "Wishlist & Saved Items",
              subtitle: "Learn how to add or remove items from wishlist.",
              destination: const WishlistPage(),
            ),
            _buildHelpTile(
              context,
              icon: Icons.location_on_outlined,
              title: "Addresses",
              subtitle: "Add, edit, or delete your saved addresses.",
              destination: const Address(),
            ),

            const SizedBox(height: 30),

            // --- FAQs ---
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQ(
              "How can I track my order?",
              "Go to ‘My Orders’ in your profile to see real-time updates and delivery details.",
            ),
            _buildFAQ(
              "Can I return a product?",
              "Yes, you can return most products within 7 days of delivery if they meet our return conditions.",
            ),
            _buildFAQ(
              "How do I reset my password?",
              "On the sign-in screen, tap ‘Forgot Password?’ and follow the instructions sent to your registered email.",
            ),
            _buildFAQ(
              "Is my payment information safe?",
              "Absolutely. We use secure payment gateways and never store your card details on our servers.",
            ),

            const SizedBox(height: 30),

            // --- Contact Section ---
            const Text(
              "Still need help?",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "If you couldn’t find your answer, feel free to contact our support team. We’re here to help 24/7.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, color: Colors.black87),
                      const SizedBox(width: 12),
                      Text(
                        "support@shoepify.com",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, color: Colors.black87),
                      const SizedBox(width: 12),
                      Text(
                        "+91 98765 43210",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "© 2025 Shoepify Support Team",
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

  // --- Common Topic Card ---
  Widget _buildHelpTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget destination,
      }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  // --- FAQ Section ---
  Widget _buildFAQ(String question, String answer) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      collapsedIconColor: Colors.black54,
      iconColor: Colors.black87,
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 12),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14.5,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
