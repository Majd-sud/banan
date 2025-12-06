import 'package:flutter/material.dart';
import '../screens/digital_fingerprint_screen.dart';
import '../screens/operations_screen.dart';
import '../screens/settings_screen.dart';

class BottomCustomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomCustomNavBar({super.key, this.currentIndex = 1});

  @override
  State<BottomCustomNavBar> createState() => _BottomCustomNavBarState();
}

class _BottomCustomNavBarState extends State<BottomCustomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, DigitalFingerprintScreen.routeName);
        break;

      case 1:
        Navigator.pushNamed(context, OperationsScreen.routeName);
        break;

      case 2:
        Navigator.pushNamed(context, SettingsScreen.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(Icons.fingerprint, "بصمتك الرقمية", 0),
          _buildBottomNavItem(Icons.donut_large_outlined, "العمليات", 1),
          _buildBottomNavItem(Icons.settings_outlined, "الإعدادات", 2),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? const Color(0xFF1B8354) : Colors.black87,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? const Color(0xFF1B8354) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
