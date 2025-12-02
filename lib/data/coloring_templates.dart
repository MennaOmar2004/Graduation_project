import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/coloring_page.dart';

// Pre-defined coloring templates with detailed patterns
class ColoringTemplates {
  static List<ColoringPage> getTemplates() {
    return [
      _createDetailedStarPattern(),
      _createDetailedMosquePattern(),
      _createDetailedFlowerPattern(),
      _createDetailedGeometricPattern(),
    ];
  }

  // Detailed Islamic Star Pattern with intricate design
  static ColoringPage _createDetailedStarPattern() {
    List<ColorRegion> regions = [];

    // Center ornate circle
    regions.add(
      ColorRegion(
        id: 'center_core',
        path: _createCirclePath(const Offset(200, 200), 25),
      ),
    );

    // Inner decorative ring
    regions.add(
      ColorRegion(
        id: 'inner_ring',
        path: _createRingPath(const Offset(200, 200), 25, 35),
      ),
    );

    // 8 main star points with detail
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;

      // Inner part of star point
      regions.add(
        ColorRegion(
          id: 'star_inner_$i',
          path: _createDetailedStarPoint(i, 200, 200, true),
        ),
      );

      // Outer part of star point
      regions.add(
        ColorRegion(
          id: 'star_outer_$i',
          path: _createDetailedStarPoint(i, 200, 200, false),
        ),
      );

      // Small decorative triangles between points
      regions.add(
        ColorRegion(id: 'triangle_$i', path: _createSmallTriangle(i, 200, 200)),
      );
    }

    // Outer decorative ring segments
    for (int i = 0; i < 8; i++) {
      regions.add(
        ColorRegion(id: 'outer_ring_$i', path: _createRingSegment(i, 200, 200)),
      );
    }

    // Corner decorations
    for (int i = 0; i < 4; i++) {
      regions.add(
        ColorRegion(id: 'corner_$i', path: _createCornerDecoration(i)),
      );
    }

    return ColoringPage(
      id: 'star_detailed',
      title: 'Detailed Islamic Star',
      titleArabic: 'نجمة إسلامية مفصلة',
      category: 'geometric',
      difficulty: 2,
      thumbnailPath: 'assets/coloring/star_thumb.png',
      regions: regions,
    );
  }

  // Detailed Mosque Pattern with minarets, domes, and decorations
  static ColoringPage _createDetailedMosquePattern() {
    List<ColorRegion> regions = [];

    // Main central dome with segments
    for (int i = 0; i < 6; i++) {
      regions.add(
        ColorRegion(
          id: 'dome_segment_$i',
          path: _createDomeSegment(200, 100, i, 6),
        ),
      );
    }

    // Dome top ornament
    regions.add(ColorRegion(id: 'dome_top', path: _createCrescentTop(200, 80)));

    // Two side domes
    regions.add(
      ColorRegion(id: 'left_small_dome', path: _createSmallDome(130, 140)),
    );

    regions.add(
      ColorRegion(id: 'right_small_dome', path: _createSmallDome(270, 140)),
    );

    // Left minaret with details
    regions.add(
      ColorRegion(id: 'left_minaret_base', path: _createMinaretBase(80, 200)),
    );
    regions.add(
      ColorRegion(id: 'left_minaret_body', path: _createMinaretBody(80, 120)),
    );
    regions.add(
      ColorRegion(
        id: 'left_minaret_balcony',
        path: _createMinaretBalcony(80, 110),
      ),
    );
    regions.add(
      ColorRegion(id: 'left_minaret_top', path: _createMinaretTop(80, 90)),
    );

    // Right minaret with details
    regions.add(
      ColorRegion(id: 'right_minaret_base', path: _createMinaretBase(320, 200)),
    );
    regions.add(
      ColorRegion(id: 'right_minaret_body', path: _createMinaretBody(320, 120)),
    );
    regions.add(
      ColorRegion(
        id: 'right_minaret_balcony',
        path: _createMinaretBalcony(320, 110),
      ),
    );
    regions.add(
      ColorRegion(id: 'right_minaret_top', path: _createMinaretTop(320, 90)),
    );

    // Main building sections
    regions.add(
      ColorRegion(
        id: 'building_left',
        path: [
          const Offset(100, 200),
          const Offset(180, 200),
          const Offset(180, 340),
          const Offset(100, 340),
        ],
      ),
    );

    regions.add(
      ColorRegion(
        id: 'building_center',
        path: [
          const Offset(180, 200),
          const Offset(220, 200),
          const Offset(220, 340),
          const Offset(180, 340),
        ],
      ),
    );

    regions.add(
      ColorRegion(
        id: 'building_right',
        path: [
          const Offset(220, 200),
          const Offset(300, 200),
          const Offset(300, 340),
          const Offset(220, 340),
        ],
      ),
    );

    // Arched windows
    for (int i = 0; i < 3; i++) {
      regions.add(
        ColorRegion(
          id: 'window_$i',
          path: _createArchedWindow(120 + i * 80, 250),
        ),
      );
    }

    // Main door with arch
    regions.add(
      ColorRegion(id: 'door_arch', path: _createArchedDoor(200, 280)),
    );

    regions.add(
      ColorRegion(
        id: 'door_panel',
        path: [
          const Offset(185, 300),
          const Offset(215, 300),
          const Offset(215, 340),
          const Offset(185, 340),
        ],
      ),
    );

    return ColoringPage(
      id: 'mosque_detailed',
      title: 'Detailed Mosque',
      titleArabic: 'مسجد مفصل',
      category: 'architecture',
      difficulty: 3,
      thumbnailPath: 'assets/coloring/mosque_thumb.png',
      regions: regions,
    );
  }

  // Detailed Flower Pattern with petals, leaves, and stem details
  static ColoringPage _createDetailedFlowerPattern() {
    List<ColorRegion> regions = [];

    // Flower center with detail
    regions.add(
      ColorRegion(
        id: 'center_core',
        path: _createCirclePath(const Offset(200, 150), 20),
      ),
    );

    // Center pattern dots
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;
      regions.add(
        ColorRegion(
          id: 'center_dot_$i',
          path: _createCirclePath(
            Offset(200 + 12 * math.cos(angle), 150 + 12 * math.sin(angle)),
            4,
          ),
        ),
      );
    }

    // 8 detailed petals with inner and outer parts
    for (int i = 0; i < 8; i++) {
      // Outer petal
      regions.add(
        ColorRegion(
          id: 'petal_outer_$i',
          path: _createDetailedPetal(i, 200, 150, false),
        ),
      );

      // Inner petal detail
      regions.add(
        ColorRegion(
          id: 'petal_inner_$i',
          path: _createDetailedPetal(i, 200, 150, true),
        ),
      );
    }

    // Stem with segments
    for (int i = 0; i < 5; i++) {
      regions.add(
        ColorRegion(
          id: 'stem_segment_$i',
          path: [
            Offset(195, 170 + i * 30),
            Offset(205, 170 + i * 30),
            Offset(205, 200 + i * 30),
            Offset(195, 200 + i * 30),
          ],
        ),
      );
    }

    // Left leaves with veins
    regions.add(
      ColorRegion(
        id: 'left_leaf_main',
        path: _createDetailedLeaf(150, 250, true, false),
      ),
    );
    regions.add(
      ColorRegion(
        id: 'left_leaf_vein',
        path: _createDetailedLeaf(150, 250, true, true),
      ),
    );

    // Right leaves with veins
    regions.add(
      ColorRegion(
        id: 'right_leaf_main',
        path: _createDetailedLeaf(250, 280, false, false),
      ),
    );
    regions.add(
      ColorRegion(
        id: 'right_leaf_vein',
        path: _createDetailedLeaf(250, 280, false, true),
      ),
    );

    // Additional small leaves
    regions.add(
      ColorRegion(
        id: 'small_leaf_left',
        path: _createSmallLeaf(170, 300, true),
      ),
    );
    regions.add(
      ColorRegion(
        id: 'small_leaf_right',
        path: _createSmallLeaf(230, 310, false),
      ),
    );

    return ColoringPage(
      id: 'flower_detailed',
      title: 'Detailed Flower',
      titleArabic: 'زهرة مفصلة',
      category: 'nature',
      difficulty: 2,
      thumbnailPath: 'assets/coloring/flower_thumb.png',
      regions: regions,
    );
  }

  // Detailed Geometric Pattern - Islamic tessellation
  static ColoringPage _createDetailedGeometricPattern() {
    List<ColorRegion> regions = [];

    // Create intricate 4x4 pattern with multiple shapes
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        double x = col * 100;
        double y = row * 100;

        // Central square
        regions.add(
          ColorRegion(
            id: 'square_${row}_${col}',
            path: _createSquare(x + 30, y + 30, 40),
          ),
        );

        // Corner triangles
        regions.add(
          ColorRegion(
            id: 'triangle_tl_${row}_${col}',
            path: [Offset(x, y), Offset(x + 30, y), Offset(x + 30, y + 30)],
          ),
        );

        regions.add(
          ColorRegion(
            id: 'triangle_tr_${row}_${col}',
            path: [
              Offset(x + 70, y),
              Offset(x + 100, y),
              Offset(x + 70, y + 30),
            ],
          ),
        );

        regions.add(
          ColorRegion(
            id: 'triangle_bl_${row}_${col}',
            path: [
              Offset(x, y + 70),
              Offset(x + 30, y + 70),
              Offset(x, y + 100),
            ],
          ),
        );

        regions.add(
          ColorRegion(
            id: 'triangle_br_${row}_${col}',
            path: [
              Offset(x + 70, y + 70),
              Offset(x + 100, y + 100),
              Offset(x + 70, y + 100),
            ],
          ),
        );

        // Side rectangles
        regions.add(
          ColorRegion(
            id: 'rect_top_${row}_${col}',
            path: [
              Offset(x + 30, y),
              Offset(x + 70, y),
              Offset(x + 70, y + 30),
              Offset(x + 30, y + 30),
            ],
          ),
        );

        regions.add(
          ColorRegion(
            id: 'rect_bottom_${row}_${col}',
            path: [
              Offset(x + 30, y + 70),
              Offset(x + 70, y + 70),
              Offset(x + 70, y + 100),
              Offset(x + 30, y + 100),
            ],
          ),
        );

        regions.add(
          ColorRegion(
            id: 'rect_left_${row}_${col}',
            path: [
              Offset(x, y + 30),
              Offset(x + 30, y + 30),
              Offset(x + 30, y + 70),
              Offset(x, y + 70),
            ],
          ),
        );

        regions.add(
          ColorRegion(
            id: 'rect_right_${row}_${col}',
            path: [
              Offset(x + 70, y + 30),
              Offset(x + 100, y + 30),
              Offset(x + 100, y + 70),
              Offset(x + 70, y + 70),
            ],
          ),
        );
      }
    }

    return ColoringPage(
      id: 'geometric_detailed',
      title: 'Detailed Geometric',
      titleArabic: 'نمط هندسي مفصل',
      category: 'geometric',
      difficulty: 3,
      thumbnailPath: 'assets/coloring/geometric_thumb.png',
      regions: regions,
    );
  }

  // Helper methods for detailed shapes
  static List<Offset> _createCirclePath(Offset center, double radius) {
    List<Offset> points = [];
    for (int i = 0; i < 36; i++) {
      double angle = (i * 10) * math.pi / 180;
      points.add(
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
      );
    }
    return points;
  }

  static List<Offset> _createRingPath(
    Offset center,
    double innerRadius,
    double outerRadius,
  ) {
    List<Offset> points = [];
    for (int i = 0; i < 36; i++) {
      double angle = (i * 10) * math.pi / 180;
      points.add(
        Offset(
          center.dx + outerRadius * math.cos(angle),
          center.dy + outerRadius * math.sin(angle),
        ),
      );
    }
    for (int i = 35; i >= 0; i--) {
      double angle = (i * 10) * math.pi / 180;
      points.add(
        Offset(
          center.dx + innerRadius * math.cos(angle),
          center.dy + innerRadius * math.sin(angle),
        ),
      );
    }
    return points;
  }

  static List<Offset> _createDetailedStarPoint(
    int index,
    double cx,
    double cy,
    bool inner,
  ) {
    double angle = (index * 45) * math.pi / 180;
    double innerRadius = inner ? 45 : 65;
    double outerRadius = inner ? 65 : 90;
    double width = inner ? 0.3 : 0.25;

    return [
      Offset(
        cx + innerRadius * math.cos(angle - width),
        cy + innerRadius * math.sin(angle - width),
      ),
      Offset(
        cx + outerRadius * math.cos(angle),
        cy + outerRadius * math.sin(angle),
      ),
      Offset(
        cx + innerRadius * math.cos(angle + width),
        cy + innerRadius * math.sin(angle + width),
      ),
    ];
  }

  static List<Offset> _createSmallTriangle(int index, double cx, double cy) {
    double angle = (index * 45 + 22.5) * math.pi / 180;
    double radius = 95;
    double size = 8;

    return [
      Offset(cx + radius * math.cos(angle), cy + radius * math.sin(angle)),
      Offset(
        cx + (radius + size) * math.cos(angle - 0.3),
        cy + (radius + size) * math.sin(angle - 0.3),
      ),
      Offset(
        cx + (radius + size) * math.cos(angle + 0.3),
        cy + (radius + size) * math.sin(angle + 0.3),
      ),
    ];
  }

  static List<Offset> _createRingSegment(int index, double cx, double cy) {
    double angle = (index * 45) * math.pi / 180;
    double innerRadius = 100;
    double outerRadius = 130;

    List<Offset> points = [];
    for (double a = angle - 0.35; a <= angle + 0.35; a += 0.1) {
      points.add(
        Offset(cx + outerRadius * math.cos(a), cy + outerRadius * math.sin(a)),
      );
    }
    for (double a = angle + 0.35; a >= angle - 0.35; a -= 0.1) {
      points.add(
        Offset(cx + innerRadius * math.cos(a), cy + innerRadius * math.sin(a)),
      );
    }
    return points;
  }

  static List<Offset> _createCornerDecoration(int index) {
    double x = index % 2 == 0 ? 20 : 380;
    double y = index < 2 ? 20 : 380;
    double size = 15;

    return [
      Offset(x, y),
      Offset(x + (index % 2 == 0 ? size : -size), y),
      Offset(x, y + (index < 2 ? size : -size)),
    ];
  }

  static List<Offset> _createDomeSegment(
    double cx,
    double cy,
    int segment,
    int total,
  ) {
    double startAngle = math.pi + (segment * math.pi / total);
    double endAngle = math.pi + ((segment + 1) * math.pi / total);
    double radius = 50;

    List<Offset> points = [Offset(cx, cy + radius)];
    for (double a = startAngle; a <= endAngle; a += 0.1) {
      points.add(Offset(cx + radius * math.cos(a), cy + radius * math.sin(a)));
    }
    points.add(Offset(cx, cy + radius));
    return points;
  }

  static List<Offset> _createCrescentTop(double cx, double cy) {
    return _createCirclePath(Offset(cx, cy), 8);
  }

  static List<Offset> _createSmallDome(double cx, double cy) {
    List<Offset> points = [];
    for (double a = math.pi; a <= 2 * math.pi; a += 0.2) {
      points.add(Offset(cx + 25 * math.cos(a), cy + 25 * math.sin(a)));
    }
    points.add(Offset(cx - 25, cy));
    return points;
  }

  static List<Offset> _createMinaretBase(double x, double y) {
    return [
      Offset(x - 12, y),
      Offset(x + 12, y),
      Offset(x + 12, y + 80),
      Offset(x - 12, y + 80),
    ];
  }

  static List<Offset> _createMinaretBody(double x, double y) {
    return [
      Offset(x - 10, y),
      Offset(x + 10, y),
      Offset(x + 10, y + 60),
      Offset(x - 10, y + 60),
    ];
  }

  static List<Offset> _createMinaretBalcony(double x, double y) {
    return [
      Offset(x - 15, y),
      Offset(x + 15, y),
      Offset(x + 12, y + 8),
      Offset(x - 12, y + 8),
    ];
  }

  static List<Offset> _createMinaretTop(double x, double y) {
    List<Offset> points = [];
    for (double a = math.pi; a <= 2 * math.pi; a += 0.3) {
      points.add(Offset(x + 12 * math.cos(a), y + 12 * math.sin(a)));
    }
    return points;
  }

  static List<Offset> _createArchedWindow(double cx, double cy) {
    List<Offset> points = [];
    for (double a = math.pi; a <= 2 * math.pi; a += 0.2) {
      points.add(Offset(cx + 12 * math.cos(a), cy + 12 * math.sin(a)));
    }
    points.add(Offset(cx + 12, cy + 25));
    points.add(Offset(cx - 12, cy + 25));
    points.add(Offset(cx - 12, cy));
    return points;
  }

  static List<Offset> _createArchedDoor(double cx, double cy) {
    List<Offset> points = [];
    for (double a = math.pi; a <= 2 * math.pi; a += 0.2) {
      points.add(Offset(cx + 15 * math.cos(a), cy + 15 * math.sin(a)));
    }
    points.add(Offset(cx - 15, cy));
    return points;
  }

  static List<Offset> _createDetailedPetal(
    int index,
    double cx,
    double cy,
    bool inner,
  ) {
    double angle = (index * 45) * math.pi / 180;
    double startRadius = inner ? 25 : 35;
    double petalLength = inner ? 35 : 55;
    double width = inner ? 0.25 : 0.35;

    return [
      Offset(
        cx + startRadius * math.cos(angle),
        cy + startRadius * math.sin(angle),
      ),
      Offset(
        cx + petalLength * math.cos(angle - width),
        cy + petalLength * math.sin(angle - width),
      ),
      Offset(
        cx + (petalLength + 10) * math.cos(angle),
        cy + (petalLength + 10) * math.sin(angle),
      ),
      Offset(
        cx + petalLength * math.cos(angle + width),
        cy + petalLength * math.sin(angle + width),
      ),
    ];
  }

  static List<Offset> _createDetailedLeaf(
    double x,
    double y,
    bool left,
    bool vein,
  ) {
    double dir = left ? -1 : 1;
    if (vein) {
      return [
        Offset(x, y),
        Offset(x + dir * 20, y - 10),
        Offset(x + dir * 25, y),
        Offset(x + dir * 20, y + 10),
      ];
    }
    return [
      Offset(x, y),
      Offset(x + dir * 35, y - 20),
      Offset(x + dir * 45, y),
      Offset(x + dir * 35, y + 20),
    ];
  }

  static List<Offset> _createSmallLeaf(double x, double y, bool left) {
    double dir = left ? -1 : 1;
    return [
      Offset(x, y),
      Offset(x + dir * 20, y - 10),
      Offset(x + dir * 25, y),
      Offset(x + dir * 20, y + 10),
    ];
  }

  static List<Offset> _createSquare(double x, double y, double size) {
    return [
      Offset(x, y),
      Offset(x + size, y),
      Offset(x + size, y + size),
      Offset(x, y + size),
    ];
  }
}
