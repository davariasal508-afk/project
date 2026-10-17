import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../models/course_model.dart';

class CourseEnrollmentScreen extends StatefulWidget {
  final Course course;

  const CourseEnrollmentScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseEnrollmentScreen> createState() => _CourseEnrollmentScreenState();
}

class _CourseEnrollmentScreenState extends State<CourseEnrollmentScreen> {
  String? _receiptImageUrl;
  final _refCodeController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _refCodeController.dispose();
    super.dispose();
  }

  void _pickMockReceipt() {
    // Simulates picking receipt image
    setState(() {
      _receiptImageUrl = 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600';
      if (_refCodeController.text.isEmpty) {
        _refCodeController.text = 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
      }
    });
  }

  void _submit() async {
    if (_receiptImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً تصویر فیش واریزی را بارگذاری نمایید.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    context.read<AppState>().submitEnrollmentRequest(
      course: widget.course,
      receiptImageUrl: _receiptImageUrl!,
      transactionRef: _refCodeController.text,
    );

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });
  }

  String _formatPrice(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('ثبت‌نام در دوره تخصصی'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Glass Course Card with Translucent Watermark
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderGold, width: 1.5),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF161E31), Color(0xFF0C101A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.12),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Translucent Watermark EO Logo
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: Opacity(
                        opacity: 0.05,
                        child: Text(
                          'EO',
                          style: TextStyle(
                            fontSize: 160,
                            fontWeight: FontWeight.w900,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ),

                    // Card Content
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  'دوره رسمی آکادمی',
                                  style: TextStyle(
                                    color: AppColors.goldLight,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'ظرفیت باقیمانده: ${course.remainingSeats} صندلی',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Text(
                            course.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Teacher & Schedule
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(course.teacherAvatar),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                course.teacherName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: AppColors.gold, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  course.schedule,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),
                          const Divider(color: AppColors.borderSubtle, height: 1),
                          const SizedBox(height: 14),

                          // Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'شهریه دوره تخصصی:',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatPrice(course.price),
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'تومان',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (_isSubmitted) ...[
                // Submitted Pending Box
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.hourglass_top, color: AppColors.warning, size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'در انتظار تأیید مدیر',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'رسید واریزی شما با موفقیت برای مدیریت ارسال گردید. پس از بازبینی و تأیید مدارک مالی توسط مدیر، دسترسی شما به کلاس‌ها و پنل هنرجو فعال خواهد شد.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.borderGold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('بازگشت به آکادمی', style: TextStyle(color: AppColors.goldLight)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Receipt Upload Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'بارگذاری فیش واریزی بانکی',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'شماره کارت اختصاصی آکادمی: ۶۰۳۷-۹۹۷۵-۱۱۱۲-۳۳۴۴\nبه نام: عرفان طاهری (بانک ملی ایران)',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Image Box or Uploader
                      if (_receiptImageUrl == null) ...[
                        InkWell(
                          onTap: _pickMockReceipt,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.gold.withOpacity(0.4),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined, color: AppColors.gold, size: 40),
                                SizedBox(height: 8),
                                Text(
                                  'انتخاب و بارگذاری تصویر فیش بانکی',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'فرمت‌های مجاز: JPG, PNG تا سقف ۵ مگابایت',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        // Receipt Preview
                        Stack(
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                  image: NetworkImage(_receiptImageUrl!),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(color: AppColors.gold),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.replay, color: AppColors.gold, size: 20),
                                      tooltip: 'تغییر تصویر رسید',
                                      onPressed: _pickMockReceipt,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                      tooltip: 'حذف رسید',
                                      onPressed: () => setState(() => _receiptImageUrl = null),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),
                      // Transaction Code Input
                      const Text(
                        'کد پیگیری یا شماره ارجاع فیش (اختیاری)',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _refCodeController,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'مثال: TRX-88371920',
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Submit Button
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  'ارسال فیش و ثبت درخواست ثبت‌نام',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
