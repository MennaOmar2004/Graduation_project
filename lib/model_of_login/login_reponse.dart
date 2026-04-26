class LoginResponse{
  final String token;
  final int parentId;
  final String fullName;

  LoginResponse({required this.token,required this.parentId,required this.fullName});

  static LoginResponse fromJson(Map<String,dynamic> json){
    return LoginResponse(
        token: json["token"],
        parentId: json["parentId"],
        fullName: json["fullName"]
    );
  }
}