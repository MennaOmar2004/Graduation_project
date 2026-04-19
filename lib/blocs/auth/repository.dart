import 'package:wanisi_app/blocs/auth/data_provider.dart';

class AuthRepository {
  final AuthDataProvider _dataProvider;

  AuthRepository({AuthDataProvider? dataProvider})
      : _dataProvider = dataProvider ?? AuthDataProvider();

  Future<Map<String, dynamic>> parentLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dataProvider.parentLogin(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> childLogin({
    required String username,
    required String pin,
  }) async {
    try {
      final response = await _dataProvider.childLogin(
        username: username,
        pin: pin,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Child login failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
