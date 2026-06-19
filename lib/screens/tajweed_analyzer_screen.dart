import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/widgets/avatar_circle.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_html/flutter_html.dart';
import 'package:audioplayers/audioplayers.dart';
import 'settings_screen.dart';
import '../services/quran_audio_service.dart';

class TajweedAnalyzerScreen extends StatefulWidget {
  const TajweedAnalyzerScreen({super.key});

  @override
  State<TajweedAnalyzerScreen> createState() => _TajweedAnalyzerScreenState();
}

class _TajweedAnalyzerScreenState extends State<TajweedAnalyzerScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final _formKey = GlobalKey<FormState>();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAudio = false;
  bool _isLoadingAudio = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlayingAudio = false);
      }
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _audioPlayer.dispose();
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {},
        onError: (val) {},
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
            if (val.finalResult) {
              setState(() => _isListening = false);
              if (_controller.text.isNotEmpty) {
                context.read<TajweedCubit>().analyzeAyah(_controller.text);
              }
            }
          },
          listenOptions: stt.SpeechListenOptions(localeId: 'ar_SA'),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_controller.text.isNotEmpty) {
        context.read<TajweedCubit>().analyzeAyah(_controller.text);
      }
    }
  }

  Future<void> _togglePlayRecitation() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'من فضلك اكتب الآية أو سجلها أولاً',
            style: AppTextStyles.snackbarText,
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_isPlayingAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingAudio = false);
      return;
    }

    setState(() => _isLoadingAudio = true);

    final audioUrl = await QuranAudioService().getAudioUrl(text);

    if (audioUrl != null) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          _isPlayingAudio = true;
          _isLoadingAudio = false;
        });
      } catch (e) {
        setState(() => _isLoadingAudio = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'فشل تشغيل الصوت. حاول مرة أخرى',
                style: AppTextStyles.snackbarText,
              ),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } else {
      setState(() => _isLoadingAudio = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'لم نجد تسجيلاً لهذه الآية',
              style: AppTextStyles.snackbarText,
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TajweedCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FF),
            body: Column(
              children: [
                _TajweedHeader(
                  onAvatar:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Input Card ──────────────────────────────────
                          _InputCard(
                            controller: _controller,
                            formKey: _formKey,
                            isListening: _isListening,
                            pulseAnimation: _pulseAnimation,
                            onMicTap: _listen,
                          ),
                          const SizedBox(height: 20),
                          // ── Action Buttons ───────────────────────────────
                          _ActionButtons(
                            isLoadingAudio: _isLoadingAudio,
                            isPlayingAudio: _isPlayingAudio,
                            onAnalyze: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<TajweedCubit>().analyzeAyah(
                                  _controller.text,
                                );
                              }
                            },
                            onListen: _togglePlayRecitation,
                          ),
                          const SizedBox(height: 28),
                          // ── Result ───────────────────────────────────────
                          BlocBuilder<TajweedCubit, TajweedState>(
                            builder: (context, state) {
                              if (state is TajweedLoading) {
                                return const _LoadingResult();
                              } else if (state is TajweedFailureState) {
                                return _ErrorResult(message: state.message);
                              } else if (state is TajweedSuccessState) {
                                return _SuccessResult(
                                  htmlContent: state.htmlContent,
                                );
                              }
                              return const _EmptyResult();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Widget
// ─────────────────────────────────────────────────────────────────────────────

class _TajweedHeader extends StatelessWidget {
  final VoidCallback onAvatar;

  const _TajweedHeader({required this.onAvatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5479FC), Color(0xFF7B9BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x335479FC),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 22),
          child: Row(
            children: [
              AvatarCircle(onTap: onAvatar),
              const Spacer(),
              // Title with icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مصحف التجويد الذكي',
                    style: AppTextStyles.buttonText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'حلل تلاوتك بالذكاء الاصطناعي',
                    style: AppTextStyles.snackbarText.copyWith(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('📖', style: TextStyle(fontSize: 22)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Input Card
// ─────────────────────────────────────────────────────────────────────────────

class _InputCard extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final bool isListening;
  final Animation<double> pulseAnimation;
  final VoidCallback onMicTap;

  const _InputCard({
    required this.controller,
    required this.formKey,
    required this.isListening,
    required this.pulseAnimation,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Label row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'اكتب الآية أو استخدم الميكروفون',
                style: AppTextStyles.linkText.copyWith(
                  fontSize: 14,
                  color: AppColors.blue_,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.blue_,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // TextField + Mic
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mic button
              _MicButton(
                isListening: isListening,
                pulseAnimation: pulseAnimation,
                onTap: onMicTap,
              ),
              const SizedBox(width: 12),
              // Text field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  minLines: 2,
                  style: AppTextStyles.linkText.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF2D2D5E),
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال آية';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'مثال: قُلْ هُوَ اللَّهُ أَحَدٌ',
                    hintStyle: AppTextStyles.linkText.copyWith(
                      fontSize: 15,
                      color: Colors.grey.shade400,
                    ),
                    hintTextDirection: TextDirection.rtl,
                    filled: true,
                    fillColor: const Color(0xFFF5F7FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.blue_,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isListening) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'جارٍ الاستماع...',
                        style: AppTextStyles.snackbarText.copyWith(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mic Button
// ─────────────────────────────────────────────────────────────────────────────

class _MicButton extends StatelessWidget {
  final bool isListening;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const _MicButton({
    required this.isListening,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
          isListening
              ? AnimatedBuilder(
                animation: pulseAnimation,
                builder:
                    (_, __) => Transform.scale(
                      scale: pulseAnimation.value,
                      child: _micContainer(isListening),
                    ),
              )
              : _micContainer(isListening),
    );
  }

  Widget _micContainer(bool listening) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            listening
                ? const LinearGradient(
                  colors: [Colors.redAccent, Color(0xFFFF6B6B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : const LinearGradient(
                  colors: [AppColors.blue_, Color(0xFF7B9BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        boxShadow: [
          BoxShadow(
            color: (listening ? Colors.red : AppColors.blue_).withValues(
              alpha: 0.35,
            ),
            blurRadius: listening ? 18 : 10,
            spreadRadius: listening ? 3 : 1,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/recorder.png',
        width: 30,
        height: 30,
        errorBuilder:
            (_, __, ___) => Icon(
              listening ? Icons.mic : Icons.mic_none_rounded,
              color: Colors.white,
              size: 26,
            ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Buttons
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final bool isLoadingAudio;
  final bool isPlayingAudio;
  final VoidCallback onAnalyze;
  final VoidCallback onListen;

  const _ActionButtons({
    required this.isLoadingAudio,
    required this.isPlayingAudio,
    required this.onAnalyze,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Listen Button
        Expanded(
          child: _PremiumButton(
            label:
                isLoadingAudio
                    ? 'جاري التحميل...'
                    : (isPlayingAudio ? 'إيقاف الاستماع' : 'استماع للشيخ'),
            icon:
                isLoadingAudio
                    ? Icons.hourglass_top_rounded
                    : (isPlayingAudio
                        ? Icons.stop_rounded
                        : Icons.volume_up_rounded),
            gradient: const LinearGradient(
              colors: [Color(0xFF52C49D), Color(0xFF3DB88B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shadowColor: const Color(0x553DB88B),
            onTap: onListen,
          ),
        ),
        const SizedBox(width: 12),
        // Analyze Button
        Expanded(
          child: _PremiumButton(
            label: 'تحليل التجويد',
            icon: Icons.auto_fix_high_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6EB4), Color(0xFFD9527A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shadowColor: const Color(0x55D9527A),
            onTap: onAnalyze,
          ),
        ),
      ],
    );
  }
}

class _PremiumButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _PremiumButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.buttonText.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Result Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingResult extends StatelessWidget {
  const _LoadingResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.blue_,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'جارٍ تحليل الآية...',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: AppColors.blue_,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorResult extends StatelessWidget {
  final String message;
  const _ErrorResult({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.snackbarText.copyWith(
                color: AppColors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessResult extends StatelessWidget {
  final String htmlContent;
  const _SuccessResult({required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Result header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5479FC), Color(0xFF7B9BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نتيجة التحليل',
                  style: AppTextStyles.buttonText.copyWith(fontSize: 15),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          // Result body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Html(
              data: htmlContent,
              style: {
                'body': Style(
                  textAlign: TextAlign.center,
                  fontSize: FontSize(26),
                  fontFamily: 'Amiri',
                  lineHeight: LineHeight(1.8),
                  color: const Color(0xFF2D2D5E),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              shape: BoxShape.circle,
            ),
            child: const Text('📖', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 14),
          Text(
            'نتيجة التجويد ستظهر هنا',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: AppColors.blue_.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اكتب آية واضغط "تحليل التجويد"',
            style: AppTextStyles.snackbarText.copyWith(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
