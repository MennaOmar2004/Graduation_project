import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/tajweed_service.dart';

sealed class TajweedState {}

class TajweedInitial extends TajweedState {}

class TajweedLoading extends TajweedState {}

class TajweedSuccessState extends TajweedState {
  final String htmlContent;

  TajweedSuccessState(this.htmlContent);
}

class TajweedFailureState extends TajweedState {
  final String message;

  TajweedFailureState(this.message);
}

class TajweedCubit extends Cubit<TajweedState> {
  final TajweedService _service;

  TajweedCubit({TajweedService? service})
      : _service = service ?? TajweedService(),
        super(TajweedInitial());

  Future<void> analyzeAyah(String text) async {
    if (text.trim().isEmpty) {
      emit(TajweedFailureState('أدخلي الآية أولاً'));
      return;
    }

    emit(TajweedLoading());

    final result = await _service.analyzeAyah(text);

    if (result is TajweedSuccess) {
      emit(TajweedSuccessState(result.html));
    } else if (result is TajweedFailure) {
      emit(TajweedFailureState(result.message));
    }
  }
}
