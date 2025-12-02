import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'components/maze_background.dart';
import 'components/collectible_component.dart';
import 'data/values_data.dart';

class MazeGame extends FlameGame with TapDetector, HasCollisionDetection {
  late MazeBackground background;
  late PlayerCharacter player;

  // Game state
  int score = 0;
  int level = 1;
  int collectedValues = 0;
  int lives = 3;
  bool isGameActive = true;
  String currentMessage = '';
  bool showMessage = false;

  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    // Add background
    background = MazeBackground();
    add(background);

    // Add floating particles
    for (int i = 0; i < 15; i++) {
      add(
        FloatingParticle(
          position: Vector2(
            _random.nextDouble() * size.x,
            _random.nextDouble() * size.y,
          ),
          color:
              [
                const Color(0xFFFFD700),
                const Color(0xFF4CAF50),
                const Color(0xFF2196F3),
                const Color(0xFFFF6B9D),
              ][_random.nextInt(4)],
          speed: _random.nextDouble() * 30 + 20,
        ),
      );
    }

    // Add player at center
    player = PlayerCharacter(position: size / 2);
    add(player);

    // Spawn initial collectibles
    _spawnCollectibles();
  }

  void _spawnCollectibles() {
    // Spawn good values in a circle pattern
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = min(size.x, size.y) * 0.35;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final x = centerX + cos(angle) * radius;
      final y = centerY + sin(angle) * radius;

      add(
        CollectibleStar(
          position: Vector2(x, y),
          value:
              ValuesDatabase.goodValues[i % ValuesDatabase.goodValues.length],
          isGood: true,
        ),
      );
    }

    // Spawn a few bad behaviors
    for (int i = 0; i < 3; i++) {
      add(
        CollectibleStar(
          position: Vector2(
            _random.nextDouble() * (size.x - 100) + 50,
            _random.nextDouble() * (size.y - 200) + 100,
          ),
          value:
              ValuesDatabase.badBehaviors[i %
                  ValuesDatabase.badBehaviors.length],
          isGood: false,
        ),
      );
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!isGameActive) return;

    // Move player to tapped position
    player.moveTo(info.eventPosition.global);
  }

  void onCollectibleCollected(CollectibleStar collectible) {
    if (collectible.isGood) {
      score += 10;
      collectedValues++;
      currentMessage =
          '${collectible.value.emoji} ${collectible.value.arabicName}!';
    } else {
      score = max(0, score - 5);
      lives--;
      currentMessage =
          '${collectible.value.emoji} تجنب ${collectible.value.arabicName}!';

      if (lives <= 0) {
        _gameOver();
        return;
      }
    }

    showMessage = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      showMessage = false;
    });

    // Check if level complete
    if (collectedValues >= 8) {
      _levelComplete();
    }
  }

  void _gameOver() {
    isGameActive = false;
    currentMessage = 'انتهت اللعبة! 😢\nالنتيجة: $score';
    showMessage = true;

    Future.delayed(const Duration(milliseconds: 3000), () {
      restartGame();
    });
  }

  void _levelComplete() {
    level++;
    collectedValues = 0;
    currentMessage = 'مستوى جديد! 🎉';
    showMessage = true;

    // Remove all collectibles
    children.whereType<CollectibleStar>().forEach((c) => c.removeFromParent());

    // Spawn new ones
    Future.delayed(const Duration(milliseconds: 2000), () {
      _spawnCollectibles();
      showMessage = false;
    });
  }

  void restartGame() {
    score = 0;
    level = 1;
    collectedValues = 0;
    lives = 3;
    isGameActive = true;
    showMessage = false;

    children.whereType<CollectibleStar>().forEach((c) => c.removeFromParent());
    player.position = size / 2;
    player.targetPosition = size / 2;

    _spawnCollectibles();
  }
}
