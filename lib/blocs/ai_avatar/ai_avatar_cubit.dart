import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanisi_app/network/cloudinary_helper.dart';
import 'package:wanisi_app/services/anime_gan_service.dart';

import 'ai_avatar_state.dart';

/// Cubit that orchestrates the AI avatar generation flow:
///   pick image → call AnimeGAN → confirm (upload to Cloudinary)
class AiAvatarCubit extends Cubit<AiAvatarState> {
  AiAvatarCubit() : super(const AiAvatarInitial());

  final _picker = ImagePicker();
  final _service = AnimeGanService();

  // ─── User picks image ───────────────────────────────────────────

  Future<void> pickImageFromGallery() async {
    final xFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (xFile == null) return; // user cancelled
    emit(AiAvatarPhotoPicked(File(xFile.path)));
  }

  Future<void> pickImageFromCamera() async {
    final xFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (xFile == null) return;
    emit(AiAvatarPhotoPicked(File(xFile.path)));
  }

  // ─── Generate anime version ─────────────────────────────────────

  Future<void> generateAnime() async {
    final current = state;
    if (current is! AiAvatarPhotoPicked) return;

    emit(const AiAvatarGenerating());

    final result = await _service.convertToAnime(current.pickedFile);

    switch (result) {
      case AnimeGanSuccess(:final imageBytes):
        emit(AiAvatarSuccess(imageBytes));
      case AnimeGanFailure(:final message):
        emit(AiAvatarFailure(message));
    }
  }

  // ─── Confirm anime & upload to Cloudinary ───────────────────────

  Future<void> confirmAnimeAvatar() async {
    final current = state;
    if (current is! AiAvatarSuccess) return;

    emit(const AiAvatarGenerating()); // reuse "loading" state for upload step

    try {
      // Write bytes to a temp file so CloudinaryHelper can upload it
      final dir = await getTemporaryDirectory();
      final tmpFile =
          File('${dir.path}/anime_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg')
            ..writeAsBytesSync(current.animeImageBytes);

      final url = await CloudinaryHelper.uploadImage(tmpFile);
      if (url != null) {
        emit(AiAvatarConfirmed(url));
      } else {
        emit(const AiAvatarFailure('فشل رفع الصورة لـ Cloudinary.'));
      }
    } catch (e) {
      emit(AiAvatarFailure('خطأ أثناء رفع الصورة: $e'));
    }
  }

  // ─── Reset ──────────────────────────────────────────────────────

  void reset() => emit(const AiAvatarInitial());

  void retryWithSamePhoto(File file) =>
      emit(AiAvatarPhotoPicked(file));
}
