import 'package:flutter/material.dart';
import 'package:mobile_store/utils/color/my_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home, 0, 'Home'),
          _buildNavItem(Icons.shopping_cart, 1, 'Cart'),
          _buildNavItem(Icons.person, 2, 'Account'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String title) {
    final isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () => onItemSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? MyColor.primaryColor : Colors.black,
            ),
            Text(title,
                style: TextStyle(
                    color: isSelected ? MyColor.primaryColor : Colors.black,
                    fontSize: 12))
          ],
        ),
      ),
    );
  }
}
