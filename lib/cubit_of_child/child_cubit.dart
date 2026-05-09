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
      emit(ChildSelectedSuccess(child));
    }catch(e){
      emit(ChildError(e.toString()));
    }
  }
  void setSelectedChild(Child child) {
    emit(ChildSelectedSuccess(child));
  }

  Future<void> updateChild({required int childId,
    required String name,
    required int age,
    required String avatarUrl,
    required String preferences
  }) async{
    try{
      emit(InitialChildState());
      final response = await dio.put("/api/v1/children/$childId",
        data: {
          "name": name,
          "age": age,
          "avatarUrl": avatarUrl,
          "preferences": preferences,
        }
      );
      print("✅ UPDATE RESPONSE: ${response.data}");

      emit(ChildUpdatedSuccess());
    }catch(e){
      emit(ChildError(e.toString()));
    }

  }
}