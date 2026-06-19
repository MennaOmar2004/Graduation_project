import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/cubit_of_child/child_cubit.dart';
import 'package:wanisi_app/cubit_of_child/child_state.dart';
import 'package:wanisi_app/cubit_of_games/game_scores_cubit.dart';
import 'package:wanisi_app/cubit_of_tasks/tasks_cubit.dart';
import 'package:wanisi_app/screens/main_layout_screen.dart';
import 'package:wanisi_app/screens/options_screen.dart';
import '../model_of_child/child.dart';

class SelectChildScreen extends StatefulWidget {
  const SelectChildScreen({super.key});

  @override
  State<SelectChildScreen> createState() => _SelectChildScreenState();
}

class _SelectChildScreenState extends State<SelectChildScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChildCubit>().getChildren();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildCubit, ChildState>(
      listener: (context, state) {
        if (state is ChildSelectedSuccess) {
          context.read<GameScoresCubit>().fetchGameScores();
          context.read<TasksCubit>().init();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OptionsScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocBuilder<ChildCubit, ChildState>(
                  builder: (context, state) {
                    if (state is InitialChildState) {
                      return const _LoadingView();
                    }
                    if (state is LoadChildFailed) {
                      return _ErrorView(message: state.error);
                    }
                    if (state is LoadChild) {
                      final children = state.childrenList;
                      if (children.isEmpty) {
                        return const _EmptyView();
                      }
                      return _ChildList(children: children);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'مرحباً بك! 👋',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 15,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اختر طفلك',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B0033),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'كل طفل له عالمه الخاص ✨',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Child List
// ---------------------------------------------------------------------------
class _ChildList extends StatelessWidget {
  final List<Child> children;
  const _ChildList({required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 350 + index * 100),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - v)),
              child: child,
            ),
          ),
          child: _ChildCard(child: children[index]),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Child Card
// ---------------------------------------------------------------------------
class _ChildCard extends StatelessWidget {
  final Child child;
  const _ChildCard({required this.child});

  static const List<Color> _accents = [
    Color(0xFF6C63FF),
    Color(0xFF48CAE4),
    Color(0xFFF472B6),
    Color(0xFFA78BFA),
    Color(0xFF4ADE80),
    Color(0xFFFBBF24),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = _accents[child.name.codeUnits.first % _accents.length];

    return GestureDetector(
      onTap: () => showStyledPinDialog(context, child),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: accent.withValues(alpha: 0.18),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              // Avatar with gradient ring
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accent.withValues(alpha: 0.18),
                          accent.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(child.avatarUrl),
                      backgroundColor: Colors.white,
                      onBackgroundImageError: (_, __) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              // Name + age
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      child.name,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B0033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'سنوات ${child.age}',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.cake_rounded, size: 15, color: accent),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Arrow button
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.1),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: accent,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading / Error / Empty
// ---------------------------------------------------------------------------
class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(color: AppColors.blue),
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          message,
          style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.child_friendly_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا يوجد أطفال مضافين بعد',
              style: GoogleFonts.cairo(color: Colors.grey[500], fontSize: 18),
            ),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// PIN Dialog
// ---------------------------------------------------------------------------
void showStyledPinDialog(BuildContext context, Child child) {
  final pinController = TextEditingController();
  String? errorText;
  bool isLoading = false;

  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return BlocListener<ChildCubit, ChildState>(
            listener: (context, state) {
              if (state is ChildSelectedSuccess) {
                context.read<GameScoresCubit>().fetchGameScores();
                context.read<TasksCubit>().init();
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MainLayout()),
                );
              }
              if (state is ChildError) {
                setState(() {
                  isLoading = false;
                  errorText = 'الرقم السري غير صحيح ❌';
                });
              }
            },
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top gradient banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(34),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              child: CircleAvatar(
                                radius: 44,
                                backgroundImage: NetworkImage(child.avatarUrl),
                                backgroundColor: Colors.white,
                                onBackgroundImageError: (_, __) {},
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              child.name,
                              style: GoogleFonts.cairo(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                        child: Column(
                          children: [
                            Text(
                              'أدخل الرقم السري 🔐',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1B0033),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // PIN field
                            TextField(
                              controller: pinController,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(
                                fontSize: 26,
                                letterSpacing: 12,
                                color: const Color(0xFF6C63FF),
                              ),
                              decoration: InputDecoration(
                                hintText: '••••',
                                hintStyle: const TextStyle(
                                  letterSpacing: 10,
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                                errorText: errorText,
                                errorStyle: GoogleFonts.cairo(
                                  color: AppColors.red,
                                  fontSize: 13,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF3F4FF),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6C63FF),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        side: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: Text(
                                      'إلغاء',
                                      style: GoogleFonts.cairo(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: _PrimaryButton(
                                    isLoading: isLoading,
                                    onPressed: () {
                                      final pin = pinController.text.trim();
                                      if (pin.isEmpty) {
                                        setState(() {
                                          errorText =
                                              'من فضلك أدخل الرقم السري';
                                        });
                                        return;
                                      }
                                      setState(() {
                                        errorText = null;
                                        isLoading = true;
                                      });
                                      context
                                          .read<ChildCubit>()
                                          .selectChild(child, pin);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Primary Button
// ---------------------------------------------------------------------------
class _PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'دخول 🚀',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}