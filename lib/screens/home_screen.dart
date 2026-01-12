import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../widgets/book_card.dart';
import '../widgets/popular_book_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookController controller = Get.put(BookController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Top Books Section
                      _buildSectionHeader('Top Books'),
                      const SizedBox(height: 20),
                      _buildTopBooksSection(controller),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE8E8E8), width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=12'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          _buildIconButton(Icons.search, () {}),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF2D3142), size: 28),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3142),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF2D3142),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderWithViewAll(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3142),
            letterSpacing: -0.5,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'View all',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBooksSection(BookController controller) {
    return Obx(
      () => SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.topBooks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == controller.topBooks.length - 1 ? 0 : 20,
              ),
              child: BookCard(book: controller.topBooks[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularBooksSection(BookController controller) {
    return Obx(
      () => SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.popularBooks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == controller.popularBooks.length - 1 ? 0 : 20,
              ),
              child: PopularBookCard(book: controller.popularBooks[index]),
            );
          },
        ),
      ),
    );
  }
}
