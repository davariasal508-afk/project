import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../models/enrollment_request_model.dart';

class ManagerEnrollmentRequestsScreen extends StatelessWidget {
  const ManagerEnrollmentRequestsScreen({Key? key}) : super(key: key);

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

  void _showReceiptDialog(BuildContext context, EnrollmentRequest req) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: AppColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderGold),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رسید واریز: ${req.userName}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    req.receiptImageUrl,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'کد پیگیری: ${req.transactionRef ?? "ثبت نشده"}',
                  style: const TextStyle(color: AppColors.goldLight, fontSize: 13),
                ),
                Text(
                  'مبلغ: ${_formatPrice(req.amount)} تومان',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  child: const Text('بستن پنجره', style: TextStyle(color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmAction(BuildContext context, EnrollmentRequest req, bool isApproval) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isApproval ? AppColors.success : AppColors.error),
          ),
          title: Text(
            isApproval ? 'تأیید فیش و ثبت‌نام دانشجو' : 'رد درخواست ثبت‌نام',
            style: TextStyle(
              color: isApproval ? AppColors.success : AppColors.error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isApproval
                ? 'آیا از صحت واریز مبلغ ${_formatPrice(req.amount)} تومان توسط ${req.userName} و ثبت‌نام رسمی ایشان اطمینان دارید؟'
                : 'آیا مایل به رد این درخواست ثبت‌نام هستید؟',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('انصراف', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                if (isApproval) {
                  context.read<AppState>().approveEnrollment(req.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'ثبت‌نام با موفقیت انجام شد',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.gold,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  context.read<AppState>().rejectEnrollment(req.id, reason: 'رسید واریز نامعتبر یا مغایرت مبلغ');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('درخواست با موفقیت رد شد.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApproval ? AppColors.success : AppColors.error,
              ),
              child: Text(
                isApproval ? 'تأیید نهایی و فعال‌سازی' : 'رد قطعی',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final requests = appState.enrollmentRequests;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('درخواست‌های ثبت‌نام و فیش‌های واریزی'),
        ),
        body: requests.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: AppColors.textMuted),
                    SizedBox(height: 12),
                    Text(
                      'هیچ درخواست ثبت‌نامی وجود ندارد',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final req = requests[index];
                  final isPending = req.status == EnrollmentStatus.pending;
                  final isApproved = req.status == EnrollmentStatus.approved;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isPending
                            ? AppColors.gold.withOpacity(0.5)
                            : isApproved
                                ? AppColors.success.withOpacity(0.4)
                                : AppColors.error.withOpacity(0.4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                req.userName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isPending
                                      ? AppColors.warning.withOpacity(0.15)
                                      : isApproved
                                          ? AppColors.success.withOpacity(0.15)
                                          : AppColors.error.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  req.status.persianTitle,
                                  style: TextStyle(
                                    color: isPending
                                        ? AppColors.warning
                                        : isApproved
                                            ? AppColors.success
                                            : AppColors.error,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'دوره: ${req.courseTitle}',
                            style: const TextStyle(color: AppColors.goldLight, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                'مبلغ: ${_formatPrice(req.amount)} تومان',
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                req.requestDate,
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Receipt Thumbnail & Action
                          Row(
                            children: [
                              InkWell(
                                onTap: () => _showReceiptDialog(context, req),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.borderGold),
                                    image: DecorationImage(
                                      image: NetworkImage(req.receiptImageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _showReceiptDialog(context, req),
                                  icon: const Icon(Icons.receipt_long, size: 16, color: AppColors.gold),
                                  label: const Text('مشاهده تصویر کامل فیش', style: TextStyle(color: AppColors.goldLight, fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.borderGold),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (isPending) ...[
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _confirmAction(context, req, true),
                                    icon: const Icon(Icons.check, size: 16, color: Colors.black),
                                    label: const Text('تأیید ثبت‌نام', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.gold,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _confirmAction(context, req, false),
                                    icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                                    label: const Text('رد فیش', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.error),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
