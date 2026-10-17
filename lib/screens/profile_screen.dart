import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('کاربری وارد نشده است')),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('پروفایل کاربری'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.error),
              tooltip: 'خروج از حساب',
              onPressed: () => context.read<AppState>().logout(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Avatar & Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: AppColors.surfaceElevated,
                        child: Text(
                          currentUser.name.substring(0, 1),
                          style: const TextStyle(fontSize: 28, color: AppColors.gold, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser.phone,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                      ),
                      child: Text(
                        currentUser.role.persianTitle,
                        style: const TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Switch user (for fast testing in Flutter)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تغییر کاربر فعال (شبیه‌ساز نقش‌ها):',
                      style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    ...appState.allUsers.map((u) {
                      final isCurrent = u.id == currentUser.id;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: isCurrent ? AppColors.gold : AppColors.surface,
                          child: Text(
                            u.name.substring(0, 1),
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrent ? Colors.black : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        title: Text(
                          u.name,
                          style: TextStyle(
                            color: isCurrent ? AppColors.goldLight : AppColors.textPrimary,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(
                          u.role.persianTitle,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                        trailing: isCurrent ? const Icon(Icons.check, color: AppColors.gold, size: 18) : null,
                        onTap: () {
                          context.read<AppState>().loginAs(u);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // About Erfan Oxigen
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('درباره استودیو و آکادمی عرفان اکسیژن', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: 6),
                    Text(
                      'مجموعه فوق لوکس عرفان اکسیژن، پیشرو در ارائه بالاترین سطح خدمات پیرایش مردانه، بیوتی استودیو و آموزش تخصصی استایلینگ و هیرکات در ایران.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
