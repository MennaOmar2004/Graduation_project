import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanisi_app/cubit_of_child/child_state.dart';
import 'package:wanisi_app/model_of_child/child.dart';
import 'package:wanisi_app/network/dio_helper.dart';

class ChildCubit extends Cubit<ChildState>{
  ChildCubit():super(InitialChildState());

  final List<Child> childrenList=[];
  final Dio dio = DioHelper.dio;
  int? selectedChildId;

  Future<void> getChildren() async{

    try{
      final response = await dio.get("/api/v1/auth/my-children");
      childrenList.clear();
      for(var child in response.data["data"]){
        childrenList.add(Child.fromJson(child));
      }
      emit(LoadChild(childrenList));
    }catch(e){
      emit(LoadChildFailed(e.toString()));
    }

  }

  Future<void> selectChild(Child child , String pinCode) async{
    try{
      final prefs =  await SharedPreferences.getInstance();
      final loginResponse = await dio.post(
        "/api/v1/auth/child/login",
        data: {
          "childId": child.id,
          "pinCode": pinCode,
        },
      );
      final token = loginResponse.data["token"];

      await prefs.setString("child_token", token);
      await prefs.setInt("childId", child.id);
      selectedChildId = child.id;
      emit(ChildSelectedSuccess(child));
    }catch(e){
      emit(ChildError(e.toString()));
    }
  }
  void setSelectedChild(Child child) {
    selectedChildId = child.id;
    emit(ChildSelectedSuccess(child));
  }

  Future<void> updateChild({
    required int childId,
    String? name,
    int? age,
    String? avatarUrl,
    String? preferences,
  }) async {

    Child? currentChild;

    if (state is ChildSelectedSuccess) {
      currentChild = (state as ChildSelectedSuccess).data;
    }

    final newName = name ?? currentChild?.name;
    final newAge = age ?? currentChild?.age;
    final newAvatar = avatarUrl ?? currentChild?.avatarUrl;

    try {
      final response = await dio.put(
        "/api/v1/children/$childId",
        data: {
          "name": newName,
          "age": newAge,
          "avatarUrl": newAvatar,
          "preferences": preferences,
        },
      );

      debugPrint(response.data);
      emit(ChildUpdatedSuccess());
      emit(
        ChildSelectedSuccess(
          Child(
            id: childId,
            name: newName!,
            age: newAge!,
            avatarUrl: newAvatar!,
          ),
        ),
      );
    } catch (e) {
      emit(ChildError(e.toString()));
    }
  }
}
