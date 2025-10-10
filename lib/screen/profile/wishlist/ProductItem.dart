import 'package:flutter/material.dart';
import 'wishlist_service.dart';

class ProductItem extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductItem({super.key, required this.product});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final _wishlistService = WishlistService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  void _checkWishlist() async {
    final exists = await _wishlistService.isInWishlist(widget.product['id']);
    setState(() => isFavorite = exists);
  }

  void _toggleWishlist() async {
    setState(() => isFavorite = !isFavorite);

    if (isFavorite) {
      await _wishlistService.addToWishlist(widget.product);
    } else {
      await _wishlistService.removeFromWishlist(widget.product['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(widget.product['image'], width: 60, height: 60),
        title: Text(widget.product['name']),
        subtitle: Text("\$${widget.product['price']}"),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: _toggleWishlist,
        ),
      ),
    );
  }
}
