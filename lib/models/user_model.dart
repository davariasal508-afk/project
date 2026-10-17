enum UserRole {
  manager,
  teacher,
  student,
  customer,
}

extension UserRoleExtension on UserRole {
  String get persianTitle {
    switch (this) {
      case UserRole.manager:
        return 'مدیریت مجموعه';
      case UserRole.teacher:
        return 'استاد آکادمی';
      case UserRole.student:
        return 'هنرجو';
      case UserRole.customer:
        return 'مشتری VIP';
    }
  }
}

class AppUser {
  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String? courseEnrolledId;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.courseEnrolledId,
  });
}
