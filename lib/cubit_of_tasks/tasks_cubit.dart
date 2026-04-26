import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanisi_app/cubit_of_tasks/tasks_State.dart';
import 'package:wanisi_app/model_of_tasks/tasks.dart';
import 'package:wanisi_app/network/dio_helper.dart';
import '../model_of_tasks/tasks_logs.dart';



class TasksCubit extends Cubit<TasksState> {
  TasksCubit():super(InitialTasksState());

  final Dio dio = DioHelper.dio;
  final List<Tasks> tasksList=[];
  final List<TasksLogs> logs = [];
  Map<String, int> completedByCategory = {};
  Map<String, int> totalByCategory = {};

  Future<void> init() async {
      emit(TasksLoading());

      await loadAllTasks();
      await loadLogs();

      recalculateAll();
      // calculateCompleted();
      // calculateSummary();
      // calculatePoints();

      emit(TasksLoaded(
          tasksList,
          points,
          completedByCategory,
          totalByCategory,
          totalDone,
          totalTasks));
  }


  // Future<void> loadTasks (String category) async{
  //   final response = await dio.get("https://waneesy.runasp.net/api/v1/tasks/category/$category");
  //   tasksList.clear();
  //   totalByCategory.clear();
  //   for (var task in response.data["data"]){
  //     tasksList.add(Tasks.fromJson(task));
  //
  //     final category = task.category;
  //     totalByCategory[category]= (totalByCategory[category]?? 0 ) + 1;
  //   }
  //   // calculatePoints();
  //   // emit(TasksLoaded(tasksList,points));
  // }

  Future<void> loadAllTasks() async {
    final categories = [
      "مهام منزلية",
      "مهام دراسية",
      "مهام سلوكية",
      "مهام دينية"
    ];

    tasksList.clear();
    totalByCategory.clear();

    for (var category in categories) {
      final response = await dio.get(
          "/api/v1/tasks/category/$category"
      );

      for (var task in response.data["data"]) {
        final t = Tasks.fromJson(task);
        tasksList.add(t);

        final cat = t.category;
        totalByCategory[cat!] = (totalByCategory[cat] ?? 0) + 1;
      }
    }
  }

  void calculateCompleted(){
    completedByCategory.clear();
    for(var log in logs){
      if(log.status=="Completed"){
        final task = tasksList.firstWhere((t) => t.id== log.taskId,);
        final category = task.category;
        completedByCategory[category!]=(completedByCategory[category]??0)+1;
      }

    }
  }

  int totalDone = 0;
  int totalTasks = 0;

  void calculateSummary() {
    totalTasks = tasksList.length;

    totalDone = logs.where((log) => log.status == "Completed").length;
  }

  int points =0;
  void calculatePoints (){
    points=logs.fold(0, (sum, log) => sum + (log.pointsEarned??0));
    print("TOTAL POINTS: $points");
  }

  void recalculateAll() {
    calculateCompleted();
    calculateSummary();
    calculatePoints();
  }

  Future <void> loadLogs() async {
    try {
      final response = await dio.get(
        "/api/v1/task-logs/my-logs",
      );

      logs.clear();

      for(var log in response.data["data"]) {
        logs.add(TasksLogs.fromJson(log));
      }

      // calculatePoints();
      // calculateCompleted();
      // calculateSummary();

    } catch (e) {
      print(e);
    }
  }

  void toggleTask(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt("childId");
    final token = prefs.getString("token");


    print("🔥 TOKEN BEFORE TASK LOG:");
    print(token);

    if (childId == null) {
      print("❌ childId is missing");
      return;
    }
    try {
      final existingLog = logs.firstWhere(
            (log) =>
        log.taskId == taskId && log.status == "Completed",
        orElse: () => TasksLogs(
          logID: null,
          taskId: null,
          status: null,
          pointsEarned: null,
        ),
      );

      if (existingLog.logID != null) {
        await dio.delete(
          "/api/v1/task-logs/${existingLog.logID}",
        );
      } else {
        await dio.post(
          "/api/v1/task-logs",
          data: {
            "childId": childId,
            "taskId": taskId,
            "isCompleted": true,
          },
        );
      }

      await loadLogs();
      recalculateAll();

      emit(TasksLoaded(List.from(tasksList),
          points,
          completedByCategory,totalByCategory,totalDone,totalTasks));


    } catch (e) {
      print(e);
    }
  }



}


