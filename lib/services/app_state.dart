import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/class_model.dart';
import '../models/enrollment_request_model.dart';

class AppState extends ChangeNotifier {
  // Current Authenticated User
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // System Users
  final List<AppUser> _users = [
    const AppUser(
      id: 'u_manager',
      name: 'عرفان اکسیژن (مدیریت)',
      phone: '09121112233',
      role: UserRole.manager,
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    const AppUser(
      id: 'u_teacher_1',
      name: 'استاد نیما راد',
      phone: '09123334455',
      role: UserRole.teacher,
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    ),
    const AppUser(
      id: 'u_student_1',
      name: 'امیرحسین پارسا',
      phone: '09124445566',
      role: UserRole.student,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      courseEnrolledId: 'c_master_fading',
    ),
    const AppUser(
      id: 'u_student_2',
      name: 'سهراب مرادی',
      phone: '09125556677',
      role: UserRole.student,
      avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150',
      courseEnrolledId: 'c_beard_architecture',
    ),
    const AppUser(
      id: 'u_student_3',
      name: 'پویا رحیمی',
      phone: '09126667788',
      role: UserRole.student,
      avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
    ),
    const AppUser(
      id: 'u_customer_1',
      name: 'دکتر کاوه کیانی',
      phone: '09127778899',
      role: UserRole.customer,
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
    ),
  ];
  List<AppUser> get allUsers => List.unmodifiable(_users);

  // Available Courses
  final List<Course> _courses = [
    const Course(
      id: 'c_master_fading',
      title: 'مستراکلاس تخصصی فید و تیپر حرفه‌ای',
      teacherName: 'عرفان اکسیژن',
      teacherAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      schedule: 'شنبه و دوشنبه‌ها • ساعت ۱۶:۰۰ الی ۱۹:۳۰',
      capacity: 12,
      enrolledCount: 9,
      price: 18500000,
      description: 'آموزش فوق تخصصی مدرن‌ترین تکنیک‌های فیدینگ اروپایی، لاینینگ، سایه و بافت‌دهی موی سر با جدیدترین ماشین‌ها و متدهای جهانی.',
      features: [
        'ارائه مدرک بین‌المللی ریجستر شده آکسفورد سرت',
        'مجموعه قیچی و شانه تخصصی برند اکسیژن',
        'ورکشاپ عملی روی ۵ مدل زنده',
        'پشتیبانی نامحدود و تضمین ورود به بازار کار'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=800',
    ),
    const Course(
      id: 'c_beard_architecture',
      title: 'معماری و زاویه‌سازی ریش با تیغ و قیچی',
      teacherName: 'استاد نیما راد',
      teacherAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      schedule: 'یک‌شنبه و سه‌شنبه‌ها • ساعت ۱۰:۰۰ الی ۱۳:۳۰',
      capacity: 10,
      enrolledCount: 7,
      price: 14200000,
      description: 'طراحی هندسی خط ریش، تکنیک‌های تیغ کشیدن سنتی بدون آسیب پوستی، بخور گرم و اوزون تراپی ریش، هیرکات تطبیقی با فرم فک.',
      features: [
        'کیت لوسیون‌ها و روغن‌های فرمولاسیون ارگانیک',
        'آموزش عکاسی تخصصی از ریش و پرتره',
        'کارگاه ۲ روزه فشرده'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=800',
    ),
    const Course(
      id: 'c_color_lab',
      title: 'آکادمی شیمی رنگ، کراتین و احیای موی آقایان',
      teacherName: 'استاد کیوان آریا',
      teacherAvatar: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150',
      schedule: 'چهارشنبه‌ها (فشرده) • ساعت ۰۹:۰۰ الی ۱۸:۰۰',
      capacity: 8,
      enrolledCount: 5,
      price: 22000000,
      description: 'شناخت پیگمنت‌ها، دکلره ایمن پایه ۹، ژورنال‌خوانی خاکستری و دودی، فرمولاسیون بوتاکس و پروتئین تراپی تخصصی مردانه.',
      features: [
        'مدرک رسمی آکادمی عرفان اکسیژن',
        'همراه با پکیج متریال اولیه ایتالیایی'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
    ),
  ];
  List<Course> get courses => List.unmodifiable(_courses);

  // Enrollment Requests
  final List<EnrollmentRequest> _enrollmentRequests = [
    EnrollmentRequest(
      id: 'req_101',
      userId: 'u_student_3',
      userName: 'پویا رحیمی',
      userPhone: '09126667788',
      courseId: 'c_master_fading',
      courseTitle: 'مستراکلاس تخصصی فید و تیپر حرفه‌ای',
      amount: 18500000,
      requestDate: '۱۴۰۳/۰۷/۱۴ - ۱۱:۳۰',
      receiptImageUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600',
      transactionRef: 'TRX-88492019',
      status: EnrollmentStatus.pending,
    ),
    EnrollmentRequest(
      id: 'req_102',
      userId: 'u_student_1',
      userName: 'امیرحسین پارسا',
      userPhone: '09124445566',
      courseId: 'c_beard_architecture',
      courseTitle: 'معماری و زاویه‌سازی ریش با تیغ و قیچی',
      amount: 14200000,
      requestDate: '۱۴۰۳/۰۷/۱۳ - ۱۶:۴۵',
      receiptImageUrl: 'https://images.unsplash.com/photo-1554224154-26032ffc0d07?w=600',
      transactionRef: 'TRX-77381920',
      status: EnrollmentStatus.approved,
    ),
  ];
  List<EnrollmentRequest> get enrollmentRequests => List.unmodifiable(_enrollmentRequests);

  // Today's Classes with Strict Visibility Control
  final List<AcademyClass> _classes = [
    const AcademyClass(
      id: 'cls_1',
      title: 'کارگاه عملی Skin Fade پیشرفته',
      courseName: 'مستراکلاس تخصصی فید و تیپر حرفه‌ای',
      teacherName: 'عرفان اکسیژن',
      date: 'امروز • ۱۵ مهر',
      startTime: '۱۶:۰۰',
      endTime: '۱۸:۰۰',
      location: 'استودیو اصلی VIP • سالن آکادمی طبقه ۲',
      status: 'در حال برگزاری',
      visibilityMode: ClassVisibilityMode.allStudents,
    ),
    const AcademyClass(
      id: 'cls_2',
      title: 'ژورنال‌خوانی و قرینه‌سازی خط ریش',
      courseName: 'معماری و زاویه‌سازی ریش',
      teacherName: 'استاد نیما راد',
      date: 'امروز • ۱۵ مهر',
      startTime: '۱۸:۳۰',
      endTime: '۲۰:۳۰',
      location: 'لابراتوار استایل شماره ۳',
      status: 'شروع به زودی',
      visibilityMode: ClassVisibilityMode.specificCourse,
      allowedCourseId: 'c_beard_architecture',
    ),
    const AcademyClass(
      id: 'cls_3',
      title: 'جلسه تخصصی مسترینگ قیچی و تکسچر (VIP خصوصی)',
      courseName: 'دوره پیشرفته تکسچر',
      teacherName: 'عرفان اکسیژن',
      date: 'امروز • ۱۵ مهر',
      startTime: '۲۰:۴۵',
      endTime: '۲۲:۰۰',
      location: 'سوئیت پرایوت آکادمی',
      status: 'شروع به زودی',
      visibilityMode: ClassVisibilityMode.selectedUsers,
      allowedUserIds: ['u_student_1', 'u_student_3'], // Only visible to these 2 students & manager
    ),
    const AcademyClass(
      id: 'cls_4',
      title: 'جلسه بازآموزی اساتید و مربیان',
      courseName: 'متدولوژی آموزش آرایشگری مدرن',
      teacherName: 'شورای آموزشی آکادمی',
      date: 'امروز • ۱۵ مهر',
      startTime: '۱۴:۰۰',
      endTime: '۱۵:۳۰',
      location: 'اتاق کنفرانس مدیریت',
      status: 'تکمیل شده',
      visibilityMode: ClassVisibilityMode.specificRoles,
      allowedRoles: [UserRole.teacher, UserRole.manager],
    ),
  ];
  List<AcademyClass> get allClasses => List.unmodifiable(_classes);

  AppState() {
    // Default to manager for rich initial experience
    _currentUser = _users.first;
  }

  // Login
  bool login(String phone) {
    final cleanPhone = phone.trim();
    final user = _users.firstWhere(
      (u) => u.phone == cleanPhone,
      orElse: () => AppUser(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: 'کاربر اکسیژن',
        phone: cleanPhone,
        role: UserRole.student,
      ),
    );
    _currentUser = user;
    notifyListeners();
    return true;
  }

  void loginAs(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Filtered Classes for Current User
  List<AcademyClass> get allowedClassesForCurrentUser {
    if (_currentUser == null) return [];
    return _classes.where((c) => c.canUserView(_currentUser!)).toList();
  }

  // Course Enrollment Request Submission
  void submitEnrollmentRequest({
    required Course course,
    required String receiptImageUrl,
    String? transactionRef,
  }) {
    if (_currentUser == null) return;

    final newReq = EnrollmentRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser!.id,
      userName: _currentUser!.name,
      userPhone: _currentUser!.phone,
      courseId: course.id,
      courseTitle: course.title,
      amount: course.price,
      requestDate: 'امروز • ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      receiptImageUrl: receiptImageUrl,
      transactionRef: transactionRef ?? 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      status: EnrollmentStatus.pending,
    );

    _enrollmentRequests.insert(0, newReq);
    notifyListeners();
  }

  // Manager Approves Enrollment
  void approveEnrollment(String requestId) {
    final index = _enrollmentRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _enrollmentRequests[index].status = EnrollmentStatus.approved;
      notifyListeners();
    }
  }

  // Manager Rejects Enrollment
  void rejectEnrollment(String requestId, {String? reason}) {
    final index = _enrollmentRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _enrollmentRequests[index].status = EnrollmentStatus.rejected;
      _enrollmentRequests[index].adminNote = reason;
      notifyListeners();
    }
  }

  // Manager Adds/Edits Class with Visibility Rules
  void addClass(AcademyClass newClass) {
    _classes.add(newClass);
    notifyListeners();
  }
}
