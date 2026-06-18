import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// States for the AI Avatar generation flow.
sealed class AiAvatarState extends Equatable {
  const AiAvatarState();

  @override
  List<Object?> get props => [];
}

/// Initial / idle state — nothing picked yet.
class AiAvatarInitial extends AiAvatarState {
  const AiAvatarInitial();
}

/// User has picked a photo but hasn't submitted it yet.
class AiAvatarPhotoPicked extends AiAvatarState {
  final File pickedFile;
  const AiAvatarPhotoPicked(this.pickedFile);

  @override
  List<Object?> get props => [pickedFile];
}

/// The AI is currently processing the image.
class AiAvatarGenerating extends AiAvatarState {
  const AiAvatarGenerating();
}

/// The AI returned a result successfully.
class AiAvatarSuccess extends AiAvatarState {
  final Uint8List animeImageBytes;
  const AiAvatarSuccess(this.animeImageBytes);

  @override
  List<Object?> get props => [animeImageBytes];
}

/// Something went wrong.
class AiAvatarFailure extends AiAvatarState {
  final String message;
  const AiAvatarFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// The user confirmed the anime image and it has been uploaded to Cloudinary.
class AiAvatarConfirmed extends AiAvatarState {
  final String cloudinaryUrl;
  const AiAvatarConfirmed(this.cloudinaryUrl);

  @override
  List<Object?> get props => [cloudinaryUrl];
}
