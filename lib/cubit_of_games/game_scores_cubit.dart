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

  // TODO: GET /api/v1/game-scores requires Admin role.
  // Temporary hardcoded admin token until backend exposes a child/parent-accessible endpoint.
  static const String _adminToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjAiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJTeXN0ZW0gQWRtaW4iLCJQYXJlbnRJZCI6IjAiLCJleHAiOjE3ODE1MzE5MTcsImlzcyI6ImtpZHNBcHBBUEkiLCJhdWQiOiJraWRzQXBwQ2xpZW50In0'
      '.YnbDq5QEjRArWkD4kY6yas8kLK27KjXwH7oXFIixnJU';

  Future<void> fetchGameScores() async {
    try {
      emit(GameScoresLoading());
      final prefs = await SharedPreferences.getInstance();
      final childId = prefs.getInt("childId");

      if (childId == null) {
        emit(const GameScoresLoaded(scores: [], totalGameScore: 0));
        return;
      }

      // Fetch games list (using Admin token as requested)
      final response = await dio.get(
        '/api/v1/games',
        options: Options(
          headers: {'Authorization': 'Bearer $_adminToken'},
        ),
      );
      
      scoresList = response.data["data"] ?? [];

      totalGameScore = scoresList.fold(0, (sum, item) {
        final score = item["score"] ?? 0;
        return sum + (score as int);
      });

      emit(
        GameScoresLoaded(scores: scoresList, totalGameScore: totalGameScore),
      );
    } catch (e) {
      // Fallback to 0 — don't crash the app if backend is unavailable
      emit(const GameScoresLoaded(scores: [], totalGameScore: 0));
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

      // POST uses the normal DioHelper interceptor token (which is now the CHILD token, resulting in 201 Created)
      await dio.post(
        '/api/v1/game-scores',
        data: {
          "childId": childId,
          "gameId": gameId,
          "score": score,
          "attempts": 0,
        },
      );

      emit(GameScoreSubmitSuccess(score));

      // Refresh scores after successful submit
      await fetchGameScores();
    } catch (e) {
      print("⚠️ Game score submit failed: $e");
    }
  }
}
