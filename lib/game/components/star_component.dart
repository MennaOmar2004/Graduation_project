import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../star_catcher_game.dart';
import 'particle_effects.dart';
import 'player_component.dart';

enum StarType {
  regular, // Normal star - 10 points
  golden, // Golden star - 25 points
  rainbow, // Rainbow star - 50 points
}

class StarComponent extends SpriteComponent
    with HasGameReference<StarCatcherGame>, CollisionCallbacks {
  final double speed;
  final StarType type;
  late StarTrailEffect trailEffect;

  StarComponent({
    required Vector2 position,
    required this.speed,
    this.type = StarType.regular,
  }) : super(position: position, size: Vector2.all(50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Load the star sprite
    sprite = await game.loadSprite('Glowing Star.png');

    // Apply color tint based on star type
    switch (type) {
      case StarType.regular:
        paint =
            Paint()
              ..colorFilter = const ColorFilter.mode(
                Color(0xFFFFD700), // Gold
                BlendMode.modulate,
              );
        break;
      case StarType.golden:
        paint =
            Paint()
              ..colorFilter = const ColorFilter.mode(
                Color(0xFFFFAA00), // Bright gold
                BlendMode.modulate,
              );
        size = Vector2.all(60); // Slightly larger
        break;
      case StarType.rainbow:
        // Rainbow stars will have animated color
        size = Vector2.all(70); // Largest
        break;
    }

    // Add collision hitbox
    add(CircleHitbox(radius: size.x / 2 * 0.8));

    // Add trail effect
    trailEffect = StarTrailEffect(parent: this);
    add(trailEffect);

    // Add rotation animation
    add(
      RotateEffect.by(2 * pi, EffectController(duration: 2.0, infinite: true)),
    );

    // Add pulsing scale animation for special stars
    if (type != StarType.regular) {
      add(
        ScaleEffect.by(
          Vector2.all(1.2),
          EffectController(duration: 0.5, infinite: true, reverseDuration: 0.5),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Fall down
    position.y += speed * dt;

    // Rainbow star color animation
    if (type == StarType.rainbow) {
      final hue = (game.currentTime() * 200) % 360;
      paint =
          Paint()
            ..colorFilter = ColorFilter.mode(
              HSLColor.fromAHSL(1.0, hue, 1.0, 0.6).toColor(),
              BlendMode.modulate,
            );
    }

    // Remove if it goes off screen (missed)
    if (position.y > game.size.y + height) {
      game.onStarMissed(this);
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
      game.onStarCollected(this);

      // Create particle effect
      game.add(StarCollectionEffect(position: position.clone()));

      removeFromParent();
    }
  }

  int getPoints() {
    switch (type) {
      case StarType.regular:
        return 10;
      case StarType.golden:
        return 25;
      case StarType.rainbow:
        return 50;
    }
  }
}

/// Star spawner with difficulty progression
class StarSpawner extends Component with HasGameReference<StarCatcherGame> {
  late Timer _timer;
  final Random _rng = Random();
  double _currentInterval = 1.5;
  double _minInterval = 0.4;
  double _difficultyTimer = 0;
  final double _difficultyIncreaseInterval =
      10.0; // Increase difficulty every 10 seconds

  StarSpawner() {
    _timer = Timer(_currentInterval, repeat: true, onTick: _spawnStar);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    _difficultyTimer += dt;

    // Increase difficulty over time
    if (_difficultyTimer >= _difficultyIncreaseInterval) {
      _difficultyTimer = 0;
      _currentInterval = max(_minInterval, _currentInterval * 0.9);
      _timer.stop();
      _timer = Timer(_currentInterval, repeat: true, onTick: _spawnStar);
      _timer.start();
    }
  }

  void _spawnStar() {
    if (!game.isGameActive) return;

    final x = _rng.nextDouble() * (game.size.x - 60) + 30;
    final baseSpeed = 150.0;
    final speedVariation = _rng.nextDouble() * 100;
    final speed =
        baseSpeed +
        speedVariation +
        (game.score / 10); // Speed increases with score

    // Determine star type (weighted random)
    StarType type;
    final random = _rng.nextDouble();
    if (random < 0.7) {
      type = StarType.regular; // 70% chance
    } else if (random < 0.95) {
      type = StarType.golden; // 25% chance
    } else {
      type = StarType.rainbow; // 5% chance
    }

    game.add(
      StarComponent(position: Vector2(x, -50), speed: speed, type: type),
    );
  }

  void reset() {
    _currentInterval = 1.5;
    _difficultyTimer = 0;
    _timer.stop();
    _timer = Timer(_currentInterval, repeat: true, onTick: _spawnStar);
    _timer.start();
  }
}
