import 'user_model.dart';

enum ClassVisibilityMode {
  allStudents,
  specificRoles,
  specificCourse,
  selectedUsers,
}

extension ClassVisibilityModeExt on ClassVisibilityMode {
  String get persianTitle {
    switch (this) {
      case ClassVisibilityMode.allStudents:
        return 'همه هنرجویان';
      case ClassVisibilityMode.specificRoles:
        return 'نقش‌های مشخص';
      case ClassVisibilityMode.specificCourse:
        return 'دوره/گروه مشخص';
      case ClassVisibilityMode.selectedUsers:
        return 'کاربران انتخاب‌شده';
    }
  }
}

class AcademyClass {
  final String id;
  final String title;
  final String courseName;
  final String teacherName;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final String status; // 'در حال برگزاری', 'شروع به زودی', 'تکمیل شده'
  
  // Visibility rules
  final ClassVisibilityMode visibilityMode;
  final List<UserRole> allowedRoles;
  final String? allowedCourseId;
  final List<String> allowedUserIds;

  const AcademyClass({
    required this.id,
    required this.title,
    required this.courseName,
    required this.teacherName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.status,
    required this.visibilityMode,
    this.allowedRoles = const [],
    this.allowedCourseId,
    this.allowedUserIds = const [],
  });

  /// Check whether a user is authorized to see this class
  bool canUserView(AppUser user) {
    if (user.role == UserRole.manager) {
      return true; // Manager always sees all classes
    }

    switch (visibilityMode) {
      case ClassVisibilityMode.allStudents:
        return user.role == UserRole.student || user.role == UserRole.teacher;

      case ClassVisibilityMode.specificRoles:
        return allowedRoles.contains(user.role);

      case ClassVisibilityMode.specificCourse:
        return user.courseEnrolledId == allowedCourseId;

      case ClassVisibilityMode.selectedUsers:
        return allowedUserIds.contains(user.id);
    }
  }
}
