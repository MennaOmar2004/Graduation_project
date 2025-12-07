import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'components/star_field.dart';
import 'components/moon_component.dart';
import 'data/moon_data.dart';

/// Beautiful moon phases educational game
class MoonPhasesGame extends FlameGame with TapDetector {
  late StarField starField;
  late MoonComponent currentMoon;
  late List<MoonPhase> shuffledPhases;

  int currentPhaseIndex = 0;
  int score = 0;
  bool isGameActive = true;

  Function(int)? onScoreChanged;
  Function(MoonPhase)? onPhaseChanged;
  Function(bool)? onAnswerSubmitted;

  @override
  Future<void> onLoad() async {
    // Add star field background
    starField = StarField()..size = size;
    add(starField);

    // Shuffle phases for gameplay
    shuffledPhases = List.from(MoonPhasesData.phases)..shuffle(math.Random());

    // Start with first phase
    _loadNextPhase();
  }

  void _loadNextPhase() {
    if (currentPhaseIndex >= shuffledPhases.length) {
      // Game complete!
      isGameActive = false;
      return;
    }

    final phase = shuffledPhases[currentPhaseIndex];

    // Create moon in center
    currentMoon = MoonComponent(
      phase: phase,
      position: Vector2(size.x / 2, size.y * 0.35),
      size: Vector2.all(size.x * 0.4),
      isInteractive: false,
    );

    add(currentMoon);
    onPhaseChanged?.call(phase);
  }

  void checkAnswer(int selectedDay) {
    if (!isGameActive) return;

    final correctDay = shuffledPhases[currentPhaseIndex].dayOfMonth;
    final isCorrect = (selectedDay - correctDay).abs() <= 2; // Allow ±2 days

    if (isCorrect) {
      score += 10;
      onScoreChanged?.call(score);
      onAnswerSubmitted?.call(true);

      // Move to next phase
      currentMoon.removeFromParent();
      currentPhaseIndex++;

      Future.delayed(const Duration(milliseconds: 800), () {
        if (isGameActive) {
          _loadNextPhase();
        }
      });
    } else {
      onAnswerSubmitted?.call(false);
    }
  }

  void restartGame() {
    currentPhaseIndex = 0;
    score = 0;
    isGameActive = true;
    shuffledPhases.shuffle(math.Random());

    currentMoon.removeFromParent();
    _loadNextPhase();

    onScoreChanged?.call(score);
  }
}
