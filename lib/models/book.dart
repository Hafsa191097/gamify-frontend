class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final double rating;
  final String coverColor;
  final String imageUrl;
  final bool isPopular;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.rating,
    required this.coverColor,
    required this.imageUrl,
    this.isPopular = false,
  });
}
