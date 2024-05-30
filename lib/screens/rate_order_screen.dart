import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_sphere_bd/models/order_product.dart';
import 'package:game_sphere_bd/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateOrderItemScreen extends StatefulWidget {
  final OrderProduct orderProduct;
  final String orderId;

  const RateOrderItemScreen(
      {super.key, required this.orderProduct, required this.orderId});

  @override
  _RateOrderItemScreenState createState() => _RateOrderItemScreenState();
}

class _RateOrderItemScreenState extends State<RateOrderItemScreen> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = true;
  bool _hasRated = false;
  String? _ratingDocId;
  final user = Constants.currentUser;

  @override
  void initState() {
    super.initState();
    _loadExistingRating();
  }

  Future<void> _loadExistingRating() async {
    final user = Constants.currentUser;
    if (user != null) {
      final ratingSnapshot = await FirebaseFirestore.instance
          .collection('product_ratings')
          .where('productId', isEqualTo: widget.orderProduct.productId)
          .where('uid', isEqualTo: user.uid)
          .where('orderId', isEqualTo: widget.orderId)
          .get();

      if (ratingSnapshot.docs.isNotEmpty) {
        final ratingData = ratingSnapshot.docs.first.data();
        setState(() {
          _rating = ratingData['rating'];
          _commentController.text = ratingData['comment'];
          _hasRated = true;
          _ratingDocId = ratingSnapshot.docs.first.id;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _submitRating() async {
    final orderProduct = widget.orderProduct;
    final user = Constants.currentUser;

    if (user != null) {
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .where('uid', isEqualTo: user.uid)
          .get();

      final String imageUrl = userDocSnapshot.docs.first.data()['imageUrl'];
      final String userName = userDocSnapshot.docs.first.data()['username'];

      final ratingData = {
        'productId': orderProduct.productId,
        'rating': _rating,
        'comment': _commentController.text,
        'timestamp': DateTime.now(),
        'uid': user.uid,
        'orderId': widget.orderId,
        'userName': userName,
        'imageUrl': imageUrl,
      };

      if (_hasRated && _ratingDocId != null) {
        // Update existing rating
        await FirebaseFirestore.instance
            .collection('product_ratings')
            .doc(_ratingDocId)
            .update(ratingData);
      } else {
        // Add new rating
        await FirebaseFirestore.instance
            .collection('product_ratings')
            .add(ratingData);
      }

      // Update average rating in the product document
      final productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(orderProduct.productId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final productSnapshot = await transaction.get(productRef);

        if (productSnapshot.exists) {
          final productData = productSnapshot.data() as Map<String, dynamic>;

          final currentRating = productData['averageRating'] ?? 0.0;
          final ratingCount = productData['ratingCount'] ?? 0;

          final newRatingCount = ratingCount + (_hasRated ? 0 : 1);
          final newAverageRating = _hasRated
              ? (currentRating * ratingCount +
                      _rating -
                      (ratingData['rating'] ?? 0)) /
                  newRatingCount
              : ((currentRating * ratingCount) + _rating) / newRatingCount;

          transaction.update(productRef, {
            'averageRating': newAverageRating,
            'ratingCount': newRatingCount,
          });
        }
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        title: const Text(
          'Item Rating',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    widget.orderProduct.productName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const ListTile(
                    leading: Text(
                      'Worst',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    trailing: Text('Excellent',
                        style: TextStyle(fontSize: 16, color: Colors.green)),
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _hasRated ? null : _submitRating,
                    child: const Text('Submit Rating'),
                  ),
                ],
              ),
            ),
    );
  }
}
