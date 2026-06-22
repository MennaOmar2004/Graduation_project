import 'dart:io';

/// All states for the Qalqlah detection flow.
sealed class QalqlahState {}

/// Initial – nothing has happened yet.
class QalqlahInitial extends QalqlahState {}

/// Recording is in progress.
class QalqlahRecording extends QalqlahState {}

/// Recording is done; file is ready to be analyzed.
class QalqlahRecorded extends QalqlahState {
  final File audioFile;
  QalqlahRecorded(this.audioFile);
}

/// Uploading + analyzing (network call in flight).
class QalqlahLoading extends QalqlahState {}

/// AI returned a result.
class QalqlahSuccess extends QalqlahState {
  final String resultText;
  QalqlahSuccess(this.resultText);
}

/// Something went wrong.
class QalqlahFailure extends QalqlahState {
  final String message;
  QalqlahFailure(this.message);
}
