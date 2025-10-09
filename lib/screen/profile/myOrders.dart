import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example mock data – replace with Firestore data later
    final orders = [
      {
        'id': 'ORD12345',
        'product': 'Nike Air Zoom Pegasus',
        'date': '02 Oct 2025',
        'status': 'Delivered',
        'image': 'https://cdn-icons-png.flaticon.com/512/2331/2331970.png',
      },
      {
        'id': 'ORD12346',
        'product': 'Apple Watch Series 9',
        'date': '29 Sep 2025',
        'status': 'Shipped',
        'image': 'https://cdn-icons-png.flaticon.com/512/892/892458.png',
      },
      {
        'id': 'ORD12347',
        'product': 'Adidas Ultraboost',
        'date': '21 Sep 2025',
        'status': 'Cancelled',
        'image': 'https://cdn-icons-png.flaticon.com/512/2331/2331970.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: orders.isEmpty
          ? const Center(
        child: Text(
          "No orders yet",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  order['image']!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                order['product']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "Order ID: ${order['id']}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "Date: ${order['date']}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['status']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: order['status'] == 'Delivered'
                          ? Colors.green
                          : order['status'] == 'Cancelled'
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black54),
              onTap: () {
                // 🔹 You can navigate to an Order Details page here later
              },
            ),
          );
        },
      ),
    );
  }
}
