class Course {
  final String id;
  final String title;
  final String teacherName;
  final String teacherAvatar;
  final String schedule;
  final int capacity;
  final int enrolledCount;
  final int price; // In Tomans
  final String description;
  final List<String> features;
  final String imageUrl;

  const Course({
    required this.id,
    required this.title,
    required this.teacherName,
    required this.teacherAvatar,
    required this.schedule,
    required this.capacity,
    required this.enrolledCount,
    required this.price,
    required this.description,
    required this.features,
    required this.imageUrl,
  });

  int get remainingSeats => capacity - enrolledCount;
}
