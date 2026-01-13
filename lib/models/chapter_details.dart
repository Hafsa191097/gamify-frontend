class Game {
  final int id;
  final int chapterId;
  final String htmlContentPath;
  final bool isApproved;
  final String createdAt;

  Game({
    required this.id,
    required this.chapterId,
    required this.htmlContentPath,
    required this.isApproved,
    required this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      chapterId: json['chapter_id'] as int,
      htmlContentPath: json['html_content_path'] as String,
      isApproved: json['is_approved'] as bool,
      createdAt: json['created_at'] as String,
    );
  }
}

class ChapterDetail {
  final int id;
  final int bookId;
  final int chapterNumber;
  final String title;
  final String summaryText;
  final String status;
  final String createdAt;
  final Game? game;

  ChapterDetail({
    required this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.title,
    required this.summaryText,
    required this.status,
    required this.createdAt,
    required this.game,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      id: json['id'] as int,
      bookId: json['book_id'] as int,
      chapterNumber: json['chapter_number'] as int,
      title: json['title'] as String,
      summaryText: json['summary_text'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      game: json['game'] != null
          ? Game.fromJson(json['game'] as Map<String, dynamic>)
          : null,
    );
  }
}
