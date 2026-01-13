import 'package:flutter/material.dart';
import 'package:gamify/screens/chapters.dart';
import 'package:get/get.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChaptersListScreen(book: book));
      },
      child: Container(
        width: 160,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Book Cover with Image or Placeholder
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: _buildBookCover(),
              ),
            ),

            // Book Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.category,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Build book cover with image or placeholder
  Widget _buildBookCover() {
    final hasValidImage =
        book.coverImageUrl != null && book.coverImageUrl!.isNotEmpty;

    if (hasValidImage) {
      return Image.network(
        book.coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _BookCoverPlaceholder(title: book.title);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _BookCoverPlaceholder(title: book.title);
        },
      );
    } else {
      return _BookCoverPlaceholder(title: book.title);
    }
  }
}

// ✅ Placeholder Widget
class _BookCoverPlaceholder extends StatelessWidget {
  final String title;

  const _BookCoverPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getColorFromString(title),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          _getFirstLetter(title),
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Get deterministic color from title
  Color _getColorFromString(String input) {
    final hash = input.hashCode.abs();
    final colors = [
      const Color(0xFF6659AA), // Purple
      const Color(0xFF4285F4), // Blue
      const Color(0xFFEA4335), // Red
      const Color(0xFF34A853), // Green
      const Color(0xFFFBBC04), // Yellow
      const Color(0xFFFA7B17), // Orange
      const Color(0xFF9C27B0), // Deep Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF2196F3), // Indigo Blue
    ];
    return colors[hash % colors.length];
  }

  // Get first letter of title
  String _getFirstLetter(String title) {
    return title.isEmpty ? '?' : title[0].toUpperCase();
  }
}
