import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper{
  static late Dio dio;

  static void init(){
    dio=Dio(
        BaseOptions(
          baseUrl: "https://waneesy.runasp.net",
          connectTimeout: const Duration(seconds: 10) ,
          receiveTimeout:const Duration(seconds: 10)
        )
    );

    // DioHelper.dart
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          String? childToken = prefs.getString("child_token");
          String? parentToken = prefs.getString("parent_token");

          // المنطق الصحيح للتوكن:
          String? token;

          // إذا كان المسار هو إنشاء طفل، اجبره يستخدم توكن الأب
          if (options.path.contains("/api/v1/children") && options.method == "POST") {
            token = parentToken;
            print("🔑 Using PARENT Token for creation");
          } else {
            // في باقي العمليات، نستخدم توكن الطفل إذا وجد، وإلا توكن الأب
            token = childToken ?? parentToken;
            print("🔑 Using ${childToken != null ? 'CHILD' : 'PARENT'} Token");
          }

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // هذه الطباعة ستخبرنا بالسبب الحقيقي للرفض من السيرفر
          print("❌ Server Reject Reason: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
  }
}