import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({Key? key}) : super(key: key);

  final BookController controller = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                isSelected: controller.selectedIndex.value == 0,
                onTap: () {
                  controller.changeTab(0);
                  Get.offAllNamed('/');
                },
              ),
              _buildNavItem(
                icon: Icons.explore_outlined,
                isSelected: controller.selectedIndex.value == 1,
                onTap: () {
                  controller.changeTab(1);
                },
              ),
              _buildNavItem(
                icon: Icons.favorite_border_rounded,
                isSelected: controller.selectedIndex.value == 2,
                onTap: () {
                  controller.changeTab(2);
                  Get.toNamed('/favorites');
                },
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                isSelected: controller.selectedIndex.value == 3,
                onTap: () {
                  controller.changeTab(3);
                  Get.toNamed('/profile');
                },
              ),
            ],
          )),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? const Color(0xFF2D3142) : const Color(0xFFBBBFC7),
        ),
      ),
    );
  }
}
