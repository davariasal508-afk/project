import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import 'today_classes_screen.dart';
import 'academy_catalog_screen.dart';
import 'beauty_studio_screen.dart';
import 'manager_enrollment_requests_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    final isManager = currentUser?.role == UserRole.manager;

    final List<Widget> pages = [
      const TodayClassesScreen(),
      const AcademyCatalogScreen(),
      const BeautyStudioScreen(),
      if (isManager) const ManagerEnrollmentRequestsScreen(),
      const ProfileScreen(),
    ];

    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined),
        activeIcon: Icon(Icons.calendar_today),
        label: 'کلاس‌های امروز',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.school_outlined),
        activeIcon: Icon(Icons.school),
        label: 'آکادمی',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.content_cut_outlined),
        activeIcon: Icon(Icons.content_cut),
        label: 'استودیو VIP',
      ),
      if (isManager)
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.receipt_long_outlined),
              if (appState.enrollmentRequests.where((r) => r.status.name == 'pending').isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                ),
            ],
          ),
          activeIcon: const Icon(Icons.receipt_long),
          label: 'درخواست‌ها',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'پروفایل',
      ),
    ];

    if (_currentIndex >= pages.length) {
      _currentIndex = 0;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.borderGold, width: 0.5),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.gold,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: navItems,
          ),
        ),
      ),
    );
  }
}
