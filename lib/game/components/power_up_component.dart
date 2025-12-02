import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../star_catcher_game.dart';
import 'particle_effects.dart';
import 'player_component.dart';

enum PowerUpType {
  magnet, // Attracts nearby stars
  shield, // Prevents losing lives
  doublePoints, // 2x points for limited time
  speedBoost, // Faster movement
}

class PowerUpComponent extends PositionComponent
    with HasGameReference<StarCatcherGame>, CollisionCallbacks {
  final PowerUpType type;
  final double speed;

  PowerUpComponent({
    required Vector2 position,
    required this.type,
    this.speed = 120,
  }) : super(position: position, size: Vector2.all(50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Create visual based on type
    final color = _getColor();
    final icon = _getIcon();

    // Background circle
    final background = CircleComponent(
      radius: 25,
      paint: Paint()..color = color,
    )..position = Vector2.all(25);
    add(background);

    // Icon
    final iconComponent =
        TextComponent(
            text: icon,
            textRenderer: TextPaint(
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
          )
          ..anchor = Anchor.center
          ..position = Vector2.all(25);
    add(iconComponent);

    // Add collision hitbox
    add(CircleHitbox(radius: 25));

    // Pulsing animation
    add(
      ScaleEffect.by(
        Vector2.all(1.3),
        EffectController(duration: 0.6, infinite: true, reverseDuration: 0.6),
      ),
    );

    // Rotation
    add(
      RotateEffect.by(2 * pi, EffectController(duration: 3.0, infinite: true)),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Fall down
    position.y += speed * dt;

    // Remove if off screen
    if (position.y > game.size.y + height) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerComponent) {
      // Collected!
      game.onPowerUpCollected(this);

      // Create particle effect
      game.add(
        PowerUpCollectionEffect(position: position.clone(), color: _getColor()),
      );

      removeFromParent();
    }
  }

  Color _getColor() {
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

  String _getIcon() {
    switch (type) {
      case PowerUpType.magnet:
        return '🧲';
      case PowerUpType.shield:
        return '🛡️';
      case PowerUpType.doublePoints:
        return '×2';
      case PowerUpType.speedBoost:
        return '⚡';
    }
  }

  double getDuration() {
    switch (type) {
      case PowerUpType.magnet:
        return 8.0;
      case PowerUpType.shield:
        return 10.0;
      case PowerUpType.doublePoints:
        return 12.0;
      case PowerUpType.speedBoost:
        return 7.0;
    }
  }
}

/// Power-up spawner
class PowerUpSpawner extends Component with HasGameReference<StarCatcherGame> {
  late Timer _timer;
  final Random _rng = Random();
  final double spawnInterval = 15.0; // Spawn every 15 seconds

  PowerUpSpawner() {
    _timer = Timer(spawnInterval, repeat: true, onTick: _spawnPowerUp);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
  }

  void _spawnPowerUp() {
    if (!game.isGameActive) return;

    final x = _rng.nextDouble() * (game.size.x - 60) + 30;

    // Random power-up type
    final types = PowerUpType.values;
    final type = types[_rng.nextInt(types.length)];

    game.add(PowerUpComponent(position: Vector2(x, -50), type: type));
  }

  void reset() {
    _timer.stop();
    _timer = Timer(spawnInterval, repeat: true, onTick: _spawnPowerUp);
    _timer.start();
  }
}

/// Active power-up tracker
class ActivePowerUp {
  final PowerUpType type;
  double remainingTime;

  ActivePowerUp({required this.type, required this.remainingTime});
}
