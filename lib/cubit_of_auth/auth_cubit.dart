import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanisi_app/cubit_of_auth/auth_state.dart';
import 'package:wanisi_app/model_of_login/login_reponse.dart';
import 'package:wanisi_app/network/dio_helper.dart';

class AuthCubit extends Cubit<AuthState>{
  AuthCubit():super(InitialAuthState());


  LoginResponse? loginData;
  final Dio dio = DioHelper.dio;

  Future <void> login ( String email , String password ) async {
    emit(AuthLoading());

    try{
      final response = await dio.post(
          "/api/v1/auth/parent/login",
          data: {
            "email": email,
            "password": password
          }
      );
      loginData = LoginResponse.fromJson(response.data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("parent_token", loginData!.token);
      await prefs.setInt("parentId", loginData!.parentId);
      await prefs.setString("fullName", loginData!.fullName);

      emit(AuthSuccess(loginData!));
    } catch(e){
      emit(AuthFailure("Login failed"));
    }
  }
}