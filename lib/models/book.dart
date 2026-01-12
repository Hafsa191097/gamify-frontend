class Book {
  final int? id;
  final String title;
  final String? coverImageUrl;
  final String? description;
  final String? status;
  final String? createdAt;
  final String author;
  final String category;
  final double rating;
  final bool isPopular;

  Book({
    this.id,
    required this.title,
    this.coverImageUrl,
    this.description,
    this.status,
    this.createdAt,
    this.author = 'Unknown',
    this.category = 'General',
    this.rating = 0.0,
    this.isPopular = false,
  });

  // Convert JSON to Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Unknown',
      coverImageUrl: json['cover_image_url'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      author: json['author'] as String? ?? 'Unknown',
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }

  // Convert Book object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover_image_url': coverImageUrl,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'author': author,
      'category': category,
      'rating': rating,
      'is_popular': isPopular,
    };
  }

  // Copy with method
  Book copyWith({
    int? id,
    String? title,
    String? coverImageUrl,
    String? description,
    String? status,
    String? createdAt,
    String? author,
    String? category,
    double? rating,
    bool? isPopular,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, status: $status)';
  }
}