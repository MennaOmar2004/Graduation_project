import 'package:flutter/foundation.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DioHelper{
//   static late Dio dio;
//
//   static void init(){
//     dio=Dio(
//         BaseOptions(
//           baseUrl: "https://waneesy.runasp.net",
//           connectTimeout: const Duration(seconds: 10) ,
//           receiveTimeout:const Duration(seconds: 10)
//         )
//     );
//
//     // DioHelper.dart
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final prefs = await SharedPreferences.getInstance();
//           String? childToken = prefs.getString("child_token");
//           String? parentToken = prefs.getString("parent_token");
//
//           // المنطق الصحيح للتوكن:
//           String? token;
//
//           // إذا كان المسار هو إنشاء طفل، اجبره يستخدم توكن الأب
//           if (options.path.contains("/api/v1/children") && options.method == "POST") {
//             token = parentToken;
//             debugPrint("🔑 Using PARENT Token for creation");
//           } else {
//             // في باقي العمليات، نستخدم توكن الطفل إذا وجد، وإلا توكن الأب
//             token = childToken ?? parentToken;
//             debugPrint("🔑 Using ${childToken != null ? 'CHILD' : 'PARENT'} Token");
//           }
//
//           if (token != null) {
//             options.headers["Authorization"] = "Bearer $token";
//           }
//
//           return handler.next(options);
//         },
//         onError: (DioException e, handler) {
//           // هذه الطباعة ستخبرنا بالسبب الحقيقي للرفض من السيرفر
//           debugPrint("❌ Server Reject Reason: ${e.response?.data}");
//           return handler.next(e);
//         },
//       ),
//     );
//   }
// }



import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://waneesy.runasp.net",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final childToken = prefs.getString("child_token");
          final parentToken = prefs.getString("parent_token");

          String? token;

          // ✅ شرط واضح ومظبوط (بدون مشاكل precedence)
          final isMyChildrenRequest =
          options.path.contains("/api/v1/auth/my-children");

          final isCreateChildRequest =
              options.path.contains("/api/v1/children") &&
                  options.method == "POST";

          final isUpdateChildRequest =
              options.path.contains("/api/v1/children") &&
                  options.method == "PUT";

          final isAvatarUploadRequest =
          options.path.contains("/avatar");

          if (isMyChildrenRequest || isCreateChildRequest || isUpdateChildRequest || isAvatarUploadRequest) {
            token = parentToken;
            debugPrint("🔑 Using PARENT Token");
          } else {
            token = childToken ?? parentToken;
            debugPrint("🔑 Using ${childToken != null ? 'CHILD' : 'PARENT'} Token");
          }

          // 🔥 مهم جدًا: طباعة التوكن اللي بيتبعت فعليًا
          debugPrint("📤 REQUEST: ${options.path}");
          debugPrint("🔐 TOKEN SENT: $token");

          if (token != null && !options.headers.containsKey("Authorization")) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint("❌ STATUS: ${e.response?.statusCode}");
          debugPrint("❌ PATH: ${e.requestOptions.path}");
          debugPrint("❌ TOKEN: ${e.requestOptions.headers['Authorization']}");
          debugPrint("❌ RESPONSE DATA: ${e.response?.data}");
          debugPrint("❌ RESPONSE HEADERS: ${e.response?.headers}");

          return handler.next(e);
        },
      ),
    );
  }
}
