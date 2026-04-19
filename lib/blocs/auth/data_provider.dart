import 'package:dio/dio.dart';
import 'package:wanisi_app/configs/api_endpoints.dart';
import 'package:wanisi_app/dio/dio.dart';

class AuthDataProvider {
  Future<Response> parentLogin({
    required String email,
    required String password,
  }) async {
    return await ApiConsumer.post(
      ApiEndpoints.parentLogin,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> childLogin({
    required String username,
    required String pin,
  }) async {
    return await ApiConsumer.post(
      ApiEndpoints.childLogin,
      data: {
        'username': username,
        'pin': pin,
      },
    );
  }

  Future<Response> switchChild({
    required int childId,
  }) async {
    return await ApiConsumer.post(
      ApiEndpoints.switchChild,
      data: {'childId': childId},
    );
  }
}
