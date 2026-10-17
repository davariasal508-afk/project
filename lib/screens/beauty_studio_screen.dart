import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BeautyStudioScreen extends StatelessWidget {
  const BeautyStudioScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _services = const [
    {
      'title': 'پکیج پیرایش و استایلینگ VIP عرفان اکسیژن',
      'category': 'VIP Hair & Beard',
      'price': '۱,۴۵۰,۰۰۰ تومان',
      'duration': '۹۰ دقیقه',
      'desc': 'شستشوی ارگانیک، هیرکات تطبیقی با فرم جمجمه، بخور گرم صورت، زاویه‌سازی ریش با تیغ سنتی ژاپنی، کراتین احیا و استایل اختصاصی.',
    },
    {
      'title': 'فشیال تخصصی پوست و پاکسازی عمیق کربن',
      'category': 'Skin & Facial Lab',
      'price': '۲,۲۰۰,۰۰۰ تومان',
      'duration': '۷۵ دقیقه',
      'desc': 'پیلینگ آنزیمی، میکرودرم ابریژن، لایت‌تراپی کلاژن‌ساز، ماسک طلا ۲۴ عیار و هیدراتاسیون عمیق پوست خسته آقایان.',
    },
    {
      'title': 'کراتینه برزیلی و احیای پروتئینی مو',
      'category': 'Hair Chemistry Lab',
      'price': '۳,۸۰۰,۰۰۰ تومان',
      'duration': '۱۲۰ دقیقه',
      'desc': 'صافی و ابریشم‌سازی مو، درمان وزی و سوختگی ناشی از دکلره با متریال اورجینال بدون فرمالدئید.',
    },
    {
      'title': 'پکیج جامع داماد رویال اکسکلوسیو (Royal Groom)',
      'category': 'Groom Exclusive',
      'price': '۹,۵۰۰,۰۰۰ تومان',
      'duration': '۴ ساعت',
      'desc': 'پکیج کامل ۳ روز قبل و روز مراسم: پاکسازی پوست، طراحی مو، گریم متعادل‌سازی محو بدون تغییر چهره، مانیکور و پدیکور VIP.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('بیوتی استودیو و سالن خدمات VIP'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _services.length,
          itemBuilder: (context, index) {
            final s = _services[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGold.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          s['category'],
                          style: const TextStyle(color: AppColors.goldLight, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(s['duration'], style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s['title'],
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s['desc'],
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s['price'],
                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('نوبت‌دهی برای "${s['title']}" ثبت گردید.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.gold),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        ),
                        child: const Text('رزرو نوبت VIP', style: TextStyle(color: AppColors.goldLight, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
