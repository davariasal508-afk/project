enum EnrollmentStatus {
  pending,  // در انتظار تأیید مدیر
  approved, // تأیید شده
  rejected, // رد شده
}

extension EnrollmentStatusExt on EnrollmentStatus {
  String get persianTitle {
    switch (this) {
      case EnrollmentStatus.pending:
        return 'در انتظار تأیید مدیر';
      case EnrollmentStatus.approved:
        return 'ثبت‌نام تأیید شده';
      case EnrollmentStatus.rejected:
        return 'درخواست رد شده';
    }
  }
}

class EnrollmentRequest {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String courseId;
  final String courseTitle;
  final int amount;
  final String requestDate;
  final String receiptImageUrl;
  final String? transactionRef;
  EnrollmentStatus status;
  String? adminNote;

  EnrollmentRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.courseId,
    required this.courseTitle,
    required this.amount,
    required this.requestDate,
    required this.receiptImageUrl,
    this.transactionRef,
    this.status = EnrollmentStatus.pending,
    this.adminNote,
  });
}
