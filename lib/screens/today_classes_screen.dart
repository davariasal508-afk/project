import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../models/class_model.dart';
import '../models/user_model.dart';
import 'manager_class_visibility_screen.dart';

class TodayClassesScreen extends StatelessWidget {
  const TodayClassesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    final allowedClasses = appState.allowedClassesForCurrentUser;
    final isManager = currentUser?.role == UserRole.manager;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('کلاس‌های امروز'),
          actions: [
            if (isManager)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.gold),
                tooltip: 'ایجاد کلاس جدید با فیلتر دسترسی',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManagerClassVisibilityScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
        body: currentUser == null
            ? const Center(child: Text('لطفاً ابتدا وارد شوید.'))
            : CustomScrollView(
                slivers: [
                  // Header Banner & Active User Info
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGold),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A1A2E), Color(0xFF0F1423)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.gold,
                              child: Text(
                                currentUser.name.substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.gold.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          currentUser.role.persianTitle,
                                          style: const TextStyle(
                                            color: AppColors.goldLight,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${allowedClasses.length} کلاس مجاز)',
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Classes List or Empty State
                  if (allowedClasses.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 64, color: AppColors.textMuted.withOpacity(0.4)),
                            const SizedBox(height: 16),
                            const Text(
                              'امروز کلاسی برای دسترسی شما تعریف نشده است',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'بر اساس سطح دسترسی و دوره‌های ثبت‌نامی شما فیلتر شده است.',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = allowedClasses[index];
                            return _buildClassCard(context, item, isManager);
                          },
                          childCount: allowedClasses.length,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, AcademyClass item, bool isManager) {
    Color statusColor;
    if (item.status.contains('درحال') || item.status.contains('در حال')) {
      statusColor = AppColors.success;
    } else if (item.status.contains('تکمیل')) {
      statusColor = AppColors.textMuted;
    } else {
      statusColor = AppColors.gold;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGold.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with status & visibility tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Text(
                    'دسترسی: ${item.visibilityMode.persianTitle}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Card Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.courseName,
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),

                // Schedule and Teacher
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.gold, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${item.startTime} تا ${item.endTime}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.person_pin, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      item.teacherName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.location,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
