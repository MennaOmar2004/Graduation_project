import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';
import 'package:wanisi_app/configs/app_spacing.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/services/quran_audio_service.dart';

import '_header.dart';
import '_input_card.dart';
import '_action_bar.dart';
import '_result_card.dart';

/// Main body widget containing all sub-widgets and controller lifecycle.
class TajweedBody extends StatefulWidget {
  const TajweedBody({super.key});

  @override
  State<TajweedBody> createState() => _TajweedBodyState();
}

class _TajweedBodyState extends State<TajweedBody> with TickerProviderStateMixin {
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: Column(
        children: [
          TajweedHeader(
            onAvatar: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Input Card ──────────────────────────────────
                    TajweedInputCard(
                      controller: _controller,
                      formKey: _formKey,
                      isListening: _isListening,
                      pulseAnimation: _pulseAnimation,
                      onMicTap: _listen,
                    ),
                    const SizedBox(height: 20),
                    // ── Action Buttons ───────────────────────────────
                    TajweedActionBar(
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
                    const TajweedResultCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
