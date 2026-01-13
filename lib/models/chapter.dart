class Chapter {
  final int id;
  final int bookId;
  final int chapterNumber;
  final String title;
  final String summaryText;
  final String status;
  final String createdAt;

  Chapter({
    required this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.title,
    required this.summaryText,
    required this.status,
    required this.createdAt,
  });

  // Parse from API JSON
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int,
      bookId: json['book_id'] as int,
      chapterNumber: json['chapter_number'] as int,
      title: json['title'] as String,
      summaryText: json['summary_text'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}

class BookDetail {
  final int id;
  final String title;
  final String? coverImageUrl;
  final String? description;
  final String status;
  final String createdAt;
  final List<Chapter> chapters;

  BookDetail({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.chapters,
  });

  // Parse from API JSON
  factory BookDetail.fromJson(Map<String, dynamic> json) {
    var chaptersList = (json['chapters'] as List)
        .map((chapter) => Chapter.fromJson(chapter as Map<String, dynamic>))
        .toList();

    return BookDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      chapters: chaptersList,
    );
  }
}
