class Tasks{
int? id ;
String? name ;
String? category ;
// bool? isCompleted;

Tasks({required this.id , required this.name , required this.category,});
static Tasks fromJson(Map <String,dynamic> json){
  return Tasks(
      id: json["taskId"],
      name: json["title"],
      category: json["category"],
      // isCompleted: json["isCompleted"],

  );
}
}
