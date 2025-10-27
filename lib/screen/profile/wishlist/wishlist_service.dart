import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  /// Get reference to the wishlist collection for the current user
  CollectionReference<Map<String, dynamic>> get _wishlistRef {
    if (uid == null) {
      throw Exception("User not logged in");
    }
    return _firestore.collection('users').doc(uid).collection('wishlist');
  }

  /// Add product to wishlist
  Future<void> addToWishlist(Map<String, dynamic> product) async {
    await _wishlistRef.doc(product['id']).set(product);
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    await _wishlistRef.doc(productId).delete();
  }

  /// Check if a product is in the wishlist
  Future<bool> isInWishlist(String productId) async {
    final doc = await _wishlistRef.doc(productId).get();
    return doc.exists;
  }

  /// Listen to wishlist changes (for UI updates)
  Stream<QuerySnapshot<Map<String, dynamic>>> get wishlistStream {
    return _wishlistRef.snapshots();
  }
}
