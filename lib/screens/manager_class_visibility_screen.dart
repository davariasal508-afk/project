import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../models/class_model.dart';
import '../models/user_model.dart';

class ManagerClassVisibilityScreen extends StatefulWidget {
  const ManagerClassVisibilityScreen({Key? key}) : super(key: key);

  @override
  State<ManagerClassVisibilityScreen> createState() => _ManagerClassVisibilityScreenState();
}

class _ManagerClassVisibilityScreenState extends State<ManagerClassVisibilityScreen> {
  final _titleController = TextEditingController(text: 'کارگاه استایلینگ VIP و فیچرینگ مو');
  final _courseController = TextEditingController(text: 'مستراکلاس تخصصی فید و تیپر حرفه‌ای');
  final _teacherController = TextEditingController(text: 'عرفان اکسیژن');
  final _startTimeController = TextEditingController(text: '۱۷:۰۰');
  final _endTimeController = TextEditingController(text: '۱۹:۰۰');
  final _locationController = TextEditingController(text: 'استودیو اصلی VIP • طبقه ۲');
  
  ClassVisibilityMode _selectedVisibilityMode = ClassVisibilityMode.selectedUsers;
  final List<String> _selectedUserIds = ['u_student_1'];
  final List<UserRole> _selectedRoles = [UserRole.student];
  String? _selectedCourseId = 'c_master_fading';

  String _searchQuery = '';

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _teacherController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveClass() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عنوان کلاس را وارد کنید')),
      );
      return;
    }

    final newClass = AcademyClass(
      id: 'cls_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      courseName: _courseController.text,
      teacherName: _teacherController.text,
      date: 'امروز • ۱۵ مهر',
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      location: _locationController.text,
      status: 'شروع به زودی',
      visibilityMode: _selectedVisibilityMode,
      allowedRoles: _selectedRoles,
      allowedCourseId: _selectedCourseId,
      allowedUserIds: List.from(_selectedUserIds),
    );

    context.read<AppState>().addClass(newClass);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('کلاس جدید با قوانین دسترسی ذخیره شد.'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final allUsers = appState.allUsers;

    final filteredUsers = allUsers.where((u) {
      if (_searchQuery.isEmpty) return true;
      return u.name.contains(_searchQuery) || u.phone.contains(_searchQuery);
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('تعریف کلاس و تنظیم سطح دسترسی'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Class General Info
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
                    const Text('مشخصات جلسه آموزشی', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'عنوان کلاس / مبحث آموزشی'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _courseController,
                      decoration: const InputDecoration(labelText: 'عنوان دوره مادر'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _startTimeController,
                            decoration: const InputDecoration(labelText: 'ساعت شروع'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _endTimeController,
                            decoration: const InputDecoration(labelText: 'ساعت پایان'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'محل برگزاری / استودیو'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Visibility Rule Selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderGold),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.visibility, color: AppColors.gold, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'کنترل دسترسی و مشاهده‌پذیری کلاس:',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'مشخص کنید دقیقاً چه کسانی اجازه دارند این جلسه را در "کلاس‌های امروز" ببینند.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 14),

                    // 4 Options Radio List
                    ...ClassVisibilityMode.values.map((mode) {
                      final isSelected = _selectedVisibilityMode == mode;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.gold.withOpacity(0.12) : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.gold : AppColors.borderSubtle,
                          ),
                        ),
                        child: RadioListTile<ClassVisibilityMode>(
                          value: mode,
                          groupValue: _selectedVisibilityMode,
                          activeColor: AppColors.gold,
                          title: Text(
                            mode.persianTitle,
                            style: TextStyle(
                              color: isSelected ? AppColors.goldLight : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedVisibilityMode = val);
                          },
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 14),

                    // Dependent Config: If "selected_users"
                    if (_selectedVisibilityMode == ClassVisibilityMode.selectedUsers) ...[
                      const Divider(color: AppColors.borderSubtle),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'انتخاب کاربران مجاز (${_selectedUserIds.length} نفر)',
                            style: const TextStyle(color: AppColors.goldLight, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          if (_selectedUserIds.isNotEmpty)
                            TextButton(
                              onPressed: () => setState(() => _selectedUserIds.clear()),
                              child: const Text('پاک کردن همه', style: TextStyle(color: AppColors.error, fontSize: 12)),
                            ),
                        ],
                      ),

                      // Selected Chips
                      if (_selectedUserIds.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _selectedUserIds.map((id) {
                            final user = allUsers.firstWhere((u) => u.id == id, orElse: () => allUsers.first);
                            return Chip(
                              backgroundColor: AppColors.gold.withOpacity(0.2),
                              side: const BorderSide(color: AppColors.gold),
                              label: Text(user.name, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                              deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.gold),
                              onDeleted: () {
                                setState(() => _selectedUserIds.remove(id));
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Search box
                      TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'جستجوی نام یا شماره هنرجو...',
                          prefixIcon: Icon(Icons.search, color: AppColors.gold, size: 20),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // User Picker List
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: ListView.separated(
                          itemCount: filteredUsers.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
                          itemBuilder: (context, index) {
                            final u = filteredUsers[index];
                            final isChecked = _selectedUserIds.contains(u.id);

                            return CheckboxListTile(
                              value: isChecked,
                              activeColor: AppColors.gold,
                              checkColor: Colors.black,
                              title: Text(u.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                              subtitle: Text('${u.role.persianTitle} • ${u.phone}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                              onChanged: (bool? checked) {
                                setState(() {
                                  if (checked == true) {
                                    if (!_selectedUserIds.contains(u.id)) _selectedUserIds.add(u.id);
                                  } else {
                                    _selectedUserIds.remove(u.id);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],

                    // If "specific_course"
                    if (_selectedVisibilityMode == ClassVisibilityMode.specificCourse) ...[
                      const SizedBox(height: 10),
                      const Text('انتخاب دوره مجاز:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCourseId,
                        dropdownColor: AppColors.surfaceElevated,
                        items: appState.courses.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.title, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedCourseId = val),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: _saveClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'ثبت و ذخیره جلسه با دسترسی انتخابی',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
