class Tasks{
int? id ;
String? name ;
String? category ;
String? taskType;
// bool? isCompleted;

Tasks({required this.id , required this.name , required this.category,required this.taskType});
static Tasks fromJson(Map <String,dynamic> json){
  return Tasks(
      id: json["taskId"],
      name: json["title"],
      category: json["category"],
      taskType: json["taskType"],
      // isCompleted: json["isCompleted"],

  );
}
}
