class Child{
  final int id;
  final String name;
  final int age;
  final String avatarUrl;

  Child({required this.id , required this.name , required this.age , required this.avatarUrl});

  static Child fromJson(Map<String,dynamic>json){
    return Child(
        id: json["id"],
        name: json["name"],
        age: json["age"],
        avatarUrl: json["avatarUrl" ]
    );
  }
}