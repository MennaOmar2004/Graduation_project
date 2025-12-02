import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/background_component.dart';
import 'components/player_component.dart';
import 'components/star_component.dart';
import 'components/power_up_component.dart';

class StarCatcherGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late PlayerComponent player;
  late StarSpawner starSpawner;
  late PowerUpSpawner powerUpSpawner;
  late BackgroundComponent background;

  // Game state
  int score = 0;
  int lives = 3;
  int combo = 0;
  int maxCombo = 0;
  bool isGameActive = true;
  bool isGameOver = false;

  // Power-ups
  final List<ActivePowerUp> activePowerUps = [];

  // Combo system
  double comboTimer = 0;
  final double comboTimeout = 2.0; // Combo resets after 2 seconds

  // Time tracking
  double _gameTime = 0;

  @override
  Future<void> onLoad() async {
    // Add background first (rendered first)
    background = BackgroundComponent();
    add(background);

    // Player
    player = PlayerComponent();
    add(player);

    // Spawners
    starSpawner = StarSpawner();
    add(starSpawner);

    powerUpSpawner = PowerUpSpawner();
    add(powerUpSpawner);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGameActive) return;

    _gameTime += dt;

    // Update combo timer
    if (combo > 0) {
      comboTimer -= dt;
      if (comboTimer <= 0) {
        combo = 0;
      }
    }

    // Update active power-ups
    for (var powerUp in List.from(activePowerUps)) {
      powerUp.remainingTime -= dt;
      if (powerUp.remainingTime <= 0) {
        activePowerUps.remove(powerUp);
      }
    }

    // Apply magnet power-up effect
    if (hasPowerUp(PowerUpType.magnet)) {
      _applyMagnetEffect();
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isGameActive) return;

    // Move player based on drag
    player.setTargetX(info.eventPosition.global.x);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // Stop player movement when drag ends
    player.velocity.x = 0;
  }

  void onStarCollected(StarComponent star) {
    if (!isGameActive) return;

    // Calculate points with multipliers
    int points = star.getPoints();

    // Apply combo multiplier
    combo++;
    if (combo > maxCombo) maxCombo = combo;
    comboTimer = comboTimeout;

    final comboMultiplier = min(combo / 5, 3.0); // Max 3x from combo
    points = (points * (1 + comboMultiplier)).round();

    // Apply double points power-up
    if (hasPowerUp(PowerUpType.doublePoints)) {
      points *= 2;
    }

    score += points;

    // Visual feedback
    player.onCatchStar();

    // TODO: Play collection sound
  }

  void onStarMissed(StarComponent star) {
    if (!isGameActive) return;

    // Only lose life for regular stars, not special ones
    if (star.type == StarType.regular) {
      // Check for shield power-up
      if (hasPowerUp(PowerUpType.shield)) {
        // Shield protects from losing life
        return;
      }

      loseLife();
    }

    // Reset combo
    combo = 0;
  }

  void onPowerUpCollected(PowerUpComponent powerUp) {
    if (!isGameActive) return;

    // Add to active power-ups
    activePowerUps.add(
      ActivePowerUp(type: powerUp.type, remainingTime: powerUp.getDuration()),
    );

    // Visual feedback
    final color = _getPowerUpColor(powerUp.type);
    player.onPowerUpCollected(color);

    // TODO: Play power-up sound
  }

  void loseLife() {
    lives--;

    if (lives <= 0) {
      gameOver();
    }

    // TODO: Play life lost sound
  }

  void gameOver() {
    isGameActive = false;
    isGameOver = true;

    // TODO: Play game over sound
  }

  void restartGame() {
    // Reset game state
    score = 0;
    lives = 3;
    combo = 0;
    maxCombo = 0;
    isGameActive = true;
    isGameOver = false;
    _gameTime = 0;
    activePowerUps.clear();

    // Remove all stars and power-ups
    children.whereType<StarComponent>().forEach(
      (star) => star.removeFromParent(),
    );
    children.whereType<PowerUpComponent>().forEach(
      (powerUp) => powerUp.removeFromParent(),
    );

    // Reset spawners
    starSpawner.reset();
    powerUpSpawner.reset();

    // Reset player position
    player.position = Vector2(size.x / 2, size.y - 120);
    player.velocity = Vector2.zero();
  }

  bool hasPowerUp(PowerUpType type) {
    return activePowerUps.any((p) => p.type == type);
  }

  double getPowerUpTimeRemaining(PowerUpType type) {
    final powerUp = activePowerUps.firstWhere(
      (p) => p.type == type,
      orElse: () => ActivePowerUp(type: type, remainingTime: 0),
    );
    return powerUp.remainingTime;
  }

  void _applyMagnetEffect() {
    // Attract nearby stars to the player
    const magnetRadius = 150.0;
    const magnetStrength = 300.0;

    for (var star in children.whereType<StarComponent>()) {
      final distance = star.position.distanceTo(player.position);
      if (distance < magnetRadius) {
        final direction = (player.position - star.position).normalized();
        star.position +=
            direction * magnetStrength * (1 / max(distance / 50, 1));
      }
    }
  }

  double currentTime() => _gameTime;

  int getComboMultiplier() {
    return min((combo / 5).floor(), 3);
  }

  Color _getPowerUpColor(PowerUpType type) {
    switch (type) {
      case PowerUpType.magnet:
        return const Color(0xFF9C27B0); // Purple
      case PowerUpType.shield:
        return const Color(0xFF2196F3); // Blue
      case PowerUpType.doublePoints:
        return const Color(0xFFFF9800); // Orange
      case PowerUpType.speedBoost:
        return const Color(0xFF4CAF50); // Green
    }
  }
}
