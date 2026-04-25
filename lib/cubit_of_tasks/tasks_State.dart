import 'package:wanisi_app/model_of_tasks/tasks.dart';

abstract class TasksState{
  const TasksState();
}


class InitialTasksState extends TasksState{
  InitialTasksState(): super ();
}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Tasks> tasksList;
  final int points;
  final Map<String, int> completedByCategory;
  final Map<String, int> totalByCategory;
  final  int totalDone ;
  final int totalTasks ;

  TasksLoaded(
      this.tasksList,
      this.points,
      this.completedByCategory,
      this.totalByCategory,
      this.totalDone,
      this.totalTasks);
}

// class TasksError extends TasksState {
//   final String message;
//   TasksError(this.message);
// }



