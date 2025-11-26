import 'package:equatable/equatable.dart';

/// State for avatar selection
class AvatarSelectionState extends Equatable {
  final String? selectedAvatar;
  final bool isConfirmed;

  const AvatarSelectionState({
    this.selectedAvatar,
    this.isConfirmed = false,
  });

  AvatarSelectionState copyWith({
    String? selectedAvatar,
    bool? isConfirmed,
  }) {
    return AvatarSelectionState(
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object?> get props => [selectedAvatar, isConfirmed];
}
