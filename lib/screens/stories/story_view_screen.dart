import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/models/story.dart';

class StoryViewScreen extends StatefulWidget {
  final Story story;

  const StoryViewScreen({super.key, required this.story});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _sparkleController;
  late ScrollController _scrollController;
  double _scrollPercentage = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _scrollController = ScrollController()..addListener(_onScroll);
    _fadeController.forward();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      setState(() {
        _scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _sparkleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Stack(
        children: [
          _buildVibrantBackground(),
          _buildFloatingMagicParticles(),
          SafeArea(
            child: Column(
              children: [
                _buildPremiumHeader(context),
                _buildProgressBar(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          _buildStoryArtCard(),
                          const SizedBox(height: 25),
                          _buildMagicalReadingCanvas(),
                          const SizedBox(height: 35),
                          _buildGoldenRewardCard(context),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVibrantBackground() {
    return Stack(
      children: [
        Container(color: const Color(0xFFF0F5FF)),
        Positioned(
          top: -100,
          right: -100,
          child: _buildBlurCircle(300, const Color(0xFFFFD1E1).withValues(alpha: 0.4)),
        ),
        Positioned(
          bottom: -50,
          left: -100,
          child: _buildBlurCircle(400, const Color(0xFFD1E1FF).withValues(alpha: 0.5)),
        ),
        Positioned(
          top: 200,
          left: -50,
          child: _buildBlurCircle(200, const Color(0xFFE1FFD1).withValues(alpha: 0.3)),
        ),
      ],
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildFloatingMagicParticles() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(15, (index) {
            final random = (index * 73) % 1000 / 1000;
            return Positioned(
              top: (MediaQuery.of(context).size.height * ((random + _sparkleController.value) % 1.0)),
              left: (MediaQuery.of(context).size.width * ((index * 0.07) % 1.0)),
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.auto_awesome,
                  size: 10 + (index % 15).toDouble(),
                  color: Colors.white,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerRight,
        widthFactor: _scrollPercentage.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_getCategoryColor(), _getCategoryColor().withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor().withValues(alpha: 0.3),
                blurRadius: 4,
                spreadRadius: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded, color: AppColors.text),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getCategoryColor(), _getCategoryColor().withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getCategoryColor().withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  widget.story.category,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryArtCard() {
    return Hero(
      tag: 'story_${widget.story.id}',
      child: Container(
        height: 260,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.story.uiColor.withValues(alpha: 0.8),
              widget.story.uiColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.story.uiColor.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Decorative background patterns
              Positioned(
                top: -30,
                right: -30,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black.withValues(alpha: 0.05),
                ),
              ),
              // Large Story Icon
              Center(
                child: Icon(
                  widget.story.uiIcon,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
              // Title Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.story.title,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMagicalReadingCanvas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white24, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(33),
            ),
            child: SelectableText(
              widget.story.text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 21,
                height: 2.2,
                color: const Color(0xFF2D3142),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoldenRewardCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF9D00)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          children: [
             _buildAnimatedTrophy(),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هدية قراءة ممتعة',
                    style: GoogleFonts.cairo(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${widget.story.points} نقطة ذهبية',
                    style: GoogleFonts.cairo(
                      color: const Color(0xFFB8860B),
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showA7santDialog(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFB8860B), Color(0xFFFFD700)]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTrophy() {
    return FadeTransition(
      opacity: _fadeController,
      child: ScaleTransition(
        scale: _fadeController,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFB8860B), size: 35),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    if (widget.story.category.contains('تربوية')) return AppColors.purple;
    if (widget.story.category.contains('دينية')) return AppColors.blue;
    return AppColors.green;
  }

  void _showA7santDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 80),
                  const SizedBox(height: 20),
                  Text('أحسنت يا بطل!', 
                    style: GoogleFonts.cairo(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCategoryColor(),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('استلم ${widget.story.points} نقطة', 
                      style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
