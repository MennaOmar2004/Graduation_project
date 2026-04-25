import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/cubit_of_tasks/tasks_State.dart';
import 'package:wanisi_app/cubit_of_tasks/tasks_cubit.dart';
import 'package:wanisi_app/model_of_tasks/tasks.dart';
import '../colors.dart';

class TasksWidget extends StatelessWidget {
  final List<Map<String, dynamic>> listItems = [
    {
      "boxColor": Color(0xDDFFFEEB),
      "boxShadowColor": Color(0xFFFFF133),
      "borderColor":  Color(0xFFFFF133)
    },
    {
      "boxColor": Color(0xFFFFE8F1),
      "boxShadowColor": Color(0xFFFCBAD3),
      "borderColor": Color(0xFFFCBAD3),
    },
    {
      "boxColor": Color(0xFFF3FFE3),
      "boxShadowColor": Color(0xFF72C076),
      "borderColor": Color(0xFF72C076),
    },
    {
      "boxColor": Color(0xFFF2DDF6),
      "boxShadowColor": Color(0xFFD66BEB),
      "borderColor": Color(0xFFD66BEB),
    },
    {
      "boxColor": Color(0xFFF6EADD),
      "boxShadowColor": Color(0xFFEBB46B),
      "borderColor": Color(0xFFEBB46B),
    },
  ];
  final List<Tasks> tasks;
  TasksWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final cubit = context.read<TasksCubit>();
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.separated(
              separatorBuilder: (context, index) =>
              const SizedBox(height: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {

                final item = listItems[index % listItems.length];
                final task = tasks[index];

                bool isDone = cubit.logs.any(
                      (log) =>
                  log.taskId == task.id &&
                      log.status == "Completed",
                );

                return Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: item["boxColor"],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: item["borderColor"].withValues(alpha: 0.7),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item["boxShadowColor"].withValues(alpha: 0.2),
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: () {
                            context
                                .read<TasksCubit>()
                                .toggleTask(task.id!);
                          },
                          child: Image.asset(
                            isDone
                                ? "assets/images/Checked Checkbox.png"
                                : "assets/images/empty_box.png",
                            width: 40,
                            height: 40,
                          ),
                        ),

                        Expanded(
                          child: Text(
                            task.name!,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.buttonText.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF9D9D9D),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

