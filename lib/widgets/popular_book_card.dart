import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/book.dart';

class PopularBookCard extends StatelessWidget {
  final Book book;

  const PopularBookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/book-detail', arguments: book);
      },
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(book.coverImageUrl ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Mock Book Cover Design
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Book Title
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Author Name
            Text(
              book.description ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
