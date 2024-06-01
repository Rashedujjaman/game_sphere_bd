import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReviewWidget extends StatelessWidget {
  final String productId;

  ReviewWidget({required this.productId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('product_ratings')
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.amber));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final review = snapshot.data?.docs ?? [];

        if (review.isEmpty) {
          return const Center(child: Text('No rating yet for this item.'));
        }

        return ListView.builder(
          shrinkWrap:
              true, // Ensure the list view takes only as much space as it needs
          physics:
              const NeverScrollableScrollPhysics(), // Prevents the list from scrolling independently
          itemCount: review.length,
          itemBuilder: (context, index) {
            final customerReview = review[index];
            final timestamp =
                (customerReview['timestamp'] as Timestamp).toDate();
            final formattedDate = DateFormat.yMMMd().format(timestamp);
            final imageUrl = customerReview['imageUrl'];
            final rating = (customerReview['rating']).toDouble();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Card(
                // color: const Color.fromARGB(255, 60, 215, 236),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2,
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: imageUrl != null || imageUrl.isNotEmpty
                          ? NetworkImage(
                              imageUrl,
                            )
                          : null,
                      child: imageUrl.isEmpty || imageUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      'Customer: ${customerReview['userName']}\n$formattedDate\nRating : $rating out of 5\nComment: ${customerReview['comment'] ?? ' '}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.amber[300],
                      child: Text('$rating',
                          style: const TextStyle(color: Colors.black)),
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
