import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryHelper {
  static final cloudinary = CloudinaryPublic(
    "do9idbnib",
    "ambnpesg",
    cache: false,
  );

  static Future<String?> uploadImage(File file) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      debugPrint("✅ Cloudinary URL: ${response.secureUrl}");

      return response.secureUrl;
    } catch (e) {
      debugPrint("❌ Cloudinary error: $e");
      return null;
    }
  }
}
