import 'package:flutter/material.dart';
import 'package:gamify/controllers/chapters.dart';
import 'package:gamify/models/chapter.dart';
import 'package:gamify/screens/chapter_details.dart';
import 'package:get/get.dart';
import '../models/book.dart';

class ChaptersListScreen extends StatelessWidget {
  final Book book;

  const ChaptersListScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChaptersController controller = Get.put(ChaptersController());

    Future.microtask(() {
      controller.getBookWithChapters(bookId: book.id!);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
        ),
        title: Text(
          book.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3142),
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6659AA),
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFEA4335),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.getBookWithChapters(bookId: book.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6659AA),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          final bookDetail = controller.bookDetail.value;
          if (bookDetail == null || bookDetail.chapters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.library_books_outlined,
                    size: 64,
                    color: Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No chapters available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            );
          }

          final sortedChapters = bookDetail.chapters
            ..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: sortedChapters.length,
            itemBuilder: (context, index) {
              final chapter = sortedChapters[index];
              return _buildChapterCard(chapter, controller);
            },
          );
        },
      ),
    );
  }

  Widget _buildChapterCard(
    Chapter chapter,
    ChaptersController controller,
  ) {
    return GestureDetector(
      onTap: () {
        // ✅ Navigate to chapter detail screen
        Get.to(
          () => ChapterDetailScreen(
            chapterId: chapter.id,
            chapterTitle: chapter.title,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6659AA),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${chapter.chapterNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              controller.getSummarySummary(chapter.summaryText),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

