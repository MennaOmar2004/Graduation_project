import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:wanisi_app/network/dio_helper.dart';
import 'game_scores_state.dart';

class GameScoresCubit extends Cubit<GameScoresState> {
  GameScoresCubit() : super(GameScoresInitial());

  final Dio dio = DioHelper.dio;

  List<dynamic> scoresList = [];
  int totalGameScore = 0;

  Future<void> fetchGameScores() async {
    try {
      emit(GameScoresLoading());

      final response = await dio.get(
        '/api/v1/game-scores/my-scores',
      );

      scoresList = response.data["data"] ?? [];

      totalGameScore = scoresList.fold(0, (sum, item) {
        return sum + ((item["score"] ?? 0) as int);
      });

      emit(
        GameScoresLoaded(
          scores: scoresList,
          totalGameScore: totalGameScore,
        ),
      );
    } catch (e) {
      debugPrint("⚠️ Error fetching game scores: $e");

      emit(
        const GameScoresLoaded(
          scores: [],
          totalGameScore: 0,
        ),
      );
    }
  }

  Future<void> submitGameScore({
    required int gameId,
    required int score,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final childId = prefs.getInt("childId");

      if (childId == null) return;

      final postData = {
        "childId": childId,
        "gameId": gameId,
        "score": score,
        "attempts": 0,
      };

      debugPrint("====================================");
      debugPrint("📤 POSTING SCORE TO BACKEND:");
      debugPrint("ENDPOINT: /api/v1/game-scores");
      debugPrint("PAYLOAD: $postData");
      debugPrint("====================================");

      await dio.post(
        '/api/v1/game-scores',
        data: postData,
      );

      emit(GameScoreSubmitSuccess(score));

      // تحديث السكورات بعد الإضافة
      await fetchGameScores();
    } catch (e) {
      debugPrint("⚠️ Game score submit failed: $e");
    }
  }
  void resetScore() {
    totalGameScore = 0;
    emit(GameScoresInitial());
  }
}
