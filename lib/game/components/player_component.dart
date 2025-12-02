import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../star_catcher_game.dart';

class PlayerComponent extends PositionComponent
    with HasGameReference<StarCatcherGame> {
  static const double playerWidth = 100;
  static const double playerHeight = 60;

  // Movement properties
  Vector2 velocity = Vector2.zero();
  final double maxSpeed = 1200;
  final double acceleration = 5000;
  final double friction = 800;

  // Visual components
  late RectangleComponent basket;
  late RectangleComponent handle;
  bool isGlowing = false;

  PlayerComponent()
    : super(size: Vector2(playerWidth, playerHeight), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Position at the bottom center
    position = Vector2(game.size.x / 2, game.size.y - 120);

    // Create basket visual (a cute basket shape)
    basket = RectangleComponent(
      size: Vector2(playerWidth, playerHeight * 0.7),
      position: Vector2(0, playerHeight * 0.3),
      paint:
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFF6B9D), // Pink
                const Color(0xFFFF4081), // Darker pink
              ],
            ).createShader(
              Rect.fromLTWH(0, 0, playerWidth, playerHeight * 0.7),
            ),
    );
    add(basket);

    // Create handle
    handle = RectangleComponent(
      size: Vector2(playerWidth * 0.8, 8),
      position: Vector2(playerWidth * 0.1, 0),
      paint: Paint()..color = const Color(0xFFFF4081),
    )..anchor = Anchor.topLeft;
    add(handle);

    // Add rim highlight
    final rim = RectangleComponent(
      size: Vector2(playerWidth, 6),
      position: Vector2(0, playerHeight * 0.3),
      paint: Paint()..color = const Color(0xFFFFB3D9),
    );
    add(rim);

    // Add collision hitbox
    add(
      RectangleHitbox(
        size: Vector2(playerWidth * 0.9, playerHeight * 0.5),
        position: Vector2(playerWidth * 0.05, playerHeight * 0.4),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply friction
    if (velocity.x.abs() > 0) {
      final frictionForce = friction * dt;
      if (velocity.x > 0) {
        velocity.x = (velocity.x - frictionForce).clamp(0, maxSpeed);
      } else {
        velocity.x = (velocity.x + frictionForce).clamp(-maxSpeed, 0);
      }
    }

    // Update position
    position += velocity * dt;

    // Clamp to screen bounds
    position.x = position.x.clamp(width / 2, game.size.x - width / 2);
  }

  void moveLeft(double dt) {
    velocity.x = (velocity.x - acceleration * dt).clamp(-maxSpeed, maxSpeed);
  }

  void moveRight(double dt) {
    velocity.x = (velocity.x + acceleration * dt).clamp(-maxSpeed, maxSpeed);
  }

  void setTargetX(double targetX) {
    // Directly set position for instant response
    position.x = targetX.clamp(width / 2, game.size.x - width / 2);
    velocity.x = 0; // Reset velocity for smooth stop
  }

  /// Visual feedback when catching a star
  void onCatchStar() {
    // Scale bounce effect
    add(
      ScaleEffect.by(
        Vector2.all(1.3),
        EffectController(duration: 0.15, reverseDuration: 0.15),
      ),
    );

    // Glow effect
    if (!isGlowing) {
      isGlowing = true;
      final originalColor = basket.paint.shader;

      basket.paint =
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFFFFF), // White glow
                const Color(0xFFFF69B4), // Pink
              ],
            ).createShader(
              Rect.fromLTWH(0, 0, playerWidth, playerHeight * 0.7),
            );

      Future.delayed(const Duration(milliseconds: 200), () {
        if (isMounted) {
          basket.paint.shader = originalColor;
          isGlowing = false;
        }
      });
    }
  }

  /// Visual feedback for power-up
  void onPowerUpCollected(Color color) {
    add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(duration: 0.2, reverseDuration: 0.2),
      ),
    );

    // Color flash
    final originalPaint = basket.paint;
    basket.paint = Paint()..color = color.withOpacity(0.8);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (isMounted) {
        basket.paint = originalPaint;
      }
    });
  }
}
