
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatelessWidget {
  final String courtType;
  const ReviewsScreen({super.key, required this.courtType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$courtType Reviews'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReviewStats(),
          const Divider(height: 32),
          _buildReviewsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReviewDialog(context),
        child: const Icon(Icons.rate_review),
      ),
    );
  }

  Widget _buildReviewStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('4.5', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.star, color: Colors.amber), Icon(Icons.star, color: Colors.amber), 
                                 Icon(Icons.star, color: Colors.amber), Icon(Icons.star, color: Colors.amber), 
                                 Icon(Icons.star_half, color: Colors.amber)]),
                    Text('Based on 28 reviews'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildReviewItem('John Doe', 5, 'Great court condition!', DateTime.now()),
        _buildReviewItem('Jane Smith', 4, 'Good facilities', DateTime.now().subtract(const Duration(days: 2))),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment, DateTime date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(DateFormat('dd MMM yyyy').format(date), style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              )),
            ),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddReviewDialog(BuildContext context) {
    final _rating = ValueNotifier<int>(5);
    final _commentController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: _rating,
              builder: (context, rating, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => _rating.value = index + 1,
                )),
              ),
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement review submission
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review submitted successfully!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}