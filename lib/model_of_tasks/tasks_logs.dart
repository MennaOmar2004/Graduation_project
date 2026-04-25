class TasksLogs{
  int? logID;
  int? taskId;
  String? status;
  int? pointsEarned;

  TasksLogs({required this.logID,required this.taskId, required this.status, required this.pointsEarned});

  static TasksLogs fromJson(Map<String,dynamic>json){
    return TasksLogs(
        logID: json["logId"],
        taskId: json["taskId"],
        status: json["status"],
        pointsEarned: json["pointsEarned"],


    );
  }
}