import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

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
    return Consumer<AuthService>(
      builder: (context, authService, _) => FutureBuilder<double>(
        future: authService.getCourtRating(courtType),
        builder: (context, snapshot) {
          final rating = snapshot.data ?? 0.0;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rating.toStringAsFixed(1), 
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              if (index < rating.floor()) {
                                return const Icon(Icons.star, color: Colors.amber);
                              } else if (index == rating.floor() && rating % 1 > 0) {
                                return const Icon(Icons.star_half, color: Colors.amber);
                              }
                              return const Icon(Icons.star_border, color: Colors.amber);
                            }),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: authService.getCourtReviews(courtType),
                            builder: (context, snapshot) {
                              final reviewCount = snapshot.data?.length ?? 0;
                              return Text('$reviewCount Review');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsList() {
    return Consumer<AuthService>(
      builder: (context, authService, _) => FutureBuilder<List<Map<String, dynamic>>>(
        future: authService.getCourtReviews(courtType),
        builder: (context, snapshot) {
          final reviews = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review Terbaru (${reviews.length})', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...reviews.map((review) => _buildReviewItem(
                review['name'], 
                review['rating'], 
                review['comment'],
                DateTime.parse(review['date']),
              )),
            ],
          );
        },
      ),
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
      builder: (context) => Consumer<AuthService>(
        builder: (context, authService, _) => AlertDialog(
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
              onPressed: () async {
                if (!authService.isAuthenticated) {
                  Navigator.pushNamed(context, '/login');
                  return;
                }
                
                await authService.addReview(courtType, {
                  'name': authService.currentUser!.name,
                  'rating': _rating.value,
                  'comment': _commentController.text,
                  'date': DateTime.now().toIso8601String(),
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review submitted successfully!')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}