
class Review {
  final String id;
  final String courtId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.courtId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}