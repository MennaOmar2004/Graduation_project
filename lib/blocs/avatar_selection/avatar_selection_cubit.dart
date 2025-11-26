import 'package:flutter_bloc/flutter_bloc.dart';
import 'avatar_selection_state.dart';

/// Cubit for managing avatar selection logic
class AvatarSelectionCubit extends Cubit<AvatarSelectionState> {
  AvatarSelectionCubit() : super(const AvatarSelectionState());

  /// Select an avatar
  void selectAvatar(String avatarPath) {
    emit(state.copyWith(selectedAvatar: avatarPath, isConfirmed: false));
  }

  /// Confirm the selected avatar
  void confirmSelection() {
    if (state.selectedAvatar != null) {
      emit(state.copyWith(isConfirmed: true));
    }
  }

  /// Clear selection
  void clearSelection() {
    emit(const AvatarSelectionState());
  }
}
