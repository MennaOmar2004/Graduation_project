import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../colors.dart';
import '../cubit_of_tasks/tasks_cubit.dart';

class PersonalTaskWidget extends StatefulWidget {
  final String category;
  const PersonalTaskWidget({super.key, required this.category});

  @override
  State<PersonalTaskWidget> createState() => _PersonalTaskWidgetState();
}

class _PersonalTaskWidgetState extends State<PersonalTaskWidget> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'كتابة مهمة جديدة 📝',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _taskController,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'مهمة جديدة',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFFF3FFE3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: _pointsController,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'النقاط',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFFF3FFE3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final taskName = _taskController.text.trim();
                final points = int.tryParse(_pointsController.text.trim()) ?? 0;
                if (taskName.isNotEmpty) {
                  // 💡 هنا يتم استدعاء دالة الـ POST من الكيوبيت وتمرير الاسم والقسم
                  context.read<TasksCubit>().addCustomTask(title: taskName, category: widget.category, pointsRewarded: points);

                  _taskController.clear();
                  Navigator.pop(bottomSheetContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2575FC),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                'إضافة المـهمة ✨',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddTaskBottomSheet(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2575FC),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2575FC).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              'اضافة مهمة ',
              style: AppTextStyles.buttonText.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

