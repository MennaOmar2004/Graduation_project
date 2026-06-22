import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:wanisi_app/services/qalqlah_service.dart';

import 'qalqlah_state.dart';

/// Cubit that manages the full Qalqlah detection lifecycle:
///   Idle → Recording → Recorded → Loading → Success | Failure
class QalqlahCubit extends Cubit<QalqlahState> {
  final QalqlahService _service;
  final AudioRecorder _recorder = AudioRecorder();
  String? _recordingPath;

  QalqlahCubit({QalqlahService? service})
      : _service = service ?? QalqlahService(),
        super(QalqlahInitial());

  // ─── Recording ───────────────────────────────────────────────────────────

  Future<void> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      emit(QalqlahFailure('يجب منح إذن الميكروفون لاستخدام هذه الميزة.'));
      return;
    }

    final dir = await getTemporaryDirectory();
    _recordingPath =
        '${dir.path}/qalqlah_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _recordingPath!,
    );
    emit(QalqlahRecording());
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stop();
    if (path == null || path.isEmpty) {
      emit(QalqlahFailure('فشل حفظ التسجيل. حاول مرة أخرى.'));
      return;
    }
    _recordingPath = path;
    emit(QalqlahRecorded(File(path)));
  }

  // ─── Analysis ────────────────────────────────────────────────────────────

  Future<void> analyzeRecording() async {
    final current = state;
    if (current is! QalqlahRecorded) return;

    emit(QalqlahLoading());

    final result = await _service.analyzeAudio(current.audioFile);

    if (result is QalqlahServiceSuccess) {
      emit(QalqlahSuccess(result.resultText));
    } else if (result is QalqlahServiceFailure) {
      emit(QalqlahFailure(result.message));
    }
  }

  // ─── Reset ───────────────────────────────────────────────────────────────

  void reset() {
    _recorder.cancel();
    emit(QalqlahInitial());
  }

  @override
  Future<void> close() async {
    await _recorder.dispose();
    return super.close();
  }
}
