import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_cubit.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_state.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/services/quran_audio_service.dart';

/// Shows the analysis result: loading spinner, error, success card, or empty.
class QalqlahResultCard extends StatelessWidget {
  const QalqlahResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QalqlahCubit, QalqlahState>(
      builder: (context, state) {
        return switch (state) {
          QalqlahLoading() => _LoadingCard(),
          QalqlahFailure(:final message) => _ErrorCard(message: message),
          QalqlahSuccess(:final resultText) => _SuccessCard(
            resultText: resultText,
          ),
          _ => _EmptyCard(),
        };
      },
    );
  }
}

// ─── Loading ────────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: Color(0xFFCA6486),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'جارٍ تحليل التسجيل...',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: const Color(0xFFCA6486),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'قد يستغرق بضع ثوان',
            style: AppTextStyles.snackbarText.copyWith(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error ──────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

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

// ─── Success ────────────────────────────────────────────────────────────────

class _SuccessCard extends StatefulWidget {
  final String resultText;
  const _SuccessCard({required this.resultText});

  @override
  State<_SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<_SuccessCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingWord;
  bool _isLoadingAudio = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _extractWord(String line) {
    // Clean bullet characters
    String cleaned = line.replaceFirst(RegExp(r'^[-*\s•]+'), '');
    // Clean "كلمة:" or "الكلمة:" prefix
    cleaned = cleaned.replaceFirst(RegExp(r'^(الكلمة|كلمة)\s*:\s*'), '');
    // Remove anything in parentheses
    cleaned = cleaned.split('(').first.trim();
    return cleaned;
  }

  Future<void> _playWordAudio(String word) async {
    if (_currentlyPlayingWord == word) {
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingWord = null;
        _isLoadingAudio = false;
      });
      return;
    }

    setState(() {
      _currentlyPlayingWord = word;
      _isLoadingAudio = true;
    });

    try {
      final audioUrl = await QuranAudioService().getAudioUrl(word);
      if (audioUrl != null && mounted) {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(audioUrl));
        _audioPlayer.onPlayerComplete.listen((_) {
          if (mounted) {
            setState(() {
              _currentlyPlayingWord = null;
              _isLoadingAudio = false;
            });
          }
        });
        setState(() {
          _isLoadingAudio = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _currentlyPlayingWord = null;
            _isLoadingAudio = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر العثور على صوت الكلمة')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentlyPlayingWord = null;
          _isLoadingAudio = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split the raw text into lines and filter blanks
    final lines =
        widget.resultText
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();

    // The rest are bullet items
    final bullets = lines.length > 1 ? lines.sublist(1) : <String>[];

    // If there are no bullets, the recitation is 100% correct
    if (bullets.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.amber.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            // Golden Trophy
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
              ),
              child: const Text('🏆', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 18),
            Text(
              'تلاوتك ممتازة وخالية من الأخطاء!',
              textAlign: TextAlign.center,
              style: AppTextStyles.linkText.copyWith(
                fontSize: 18,
                color: Colors.amber.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'أحسنت يا بطل! لقد قرأت أحرف القلقلة بشكل صحيح تماماً. استمر في هذا الأداء الرائع! 🌟👏',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.snackbarText.copyWith(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCA6486).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gradient header bar ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Color.fromARGB(255, 161, 67, 81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نتيجة كشف القلقلة',
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
          // ── Result body ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Friendly header/instruction
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    Expanded(
                      child: Text(
                        'محاولة رائعة يا بطل! فلنتدرب معاً على نطق الكلمات التالية لتصبح تلاوتك ممتازة: ✨',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.linkText.copyWith(
                          fontSize: 15,
                          color: const Color(0xFF2D2D5E),
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('💡', style: TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Single play button for the whole Ayah ──────────
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCA6486).withValues(alpha: 0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 0,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Join word search query to fetch the correct Ayah pronunciation
                        final combinedQuery = bullets
                            .map(_extractWord)
                            .join(' ');
                        _playWordAudio(combinedQuery);
                      },
                      icon:
                          _isLoadingAudio
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(
                                _currentlyPlayingWord != null
                                    ? Icons.stop_rounded
                                    : Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                      label: Text(
                        _currentlyPlayingWord != null
                            ? 'إيقاف الصوت'
                            : 'استمع للآية الكريمة',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCA6486),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 18),

                // Static tactile badges layout (clean, no volume play button)
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    textDirection: TextDirection.rtl,
                    children:
                        bullets.map((line) {
                          final word = _extractWord(line);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F3), // Soft pink bg
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFCA6486),
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFCA6486,
                                  ).withValues(alpha: 0.2),
                                  offset: const Offset(0, 4),
                                  blurRadius: 0,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              textDirection: TextDirection.rtl,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFCA6486),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  word,
                                  style: AppTextStyles.numberText.copyWith(
                                    fontSize: 17,
                                    color: const Color(0xFFCA6486),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty ──────────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Text('🔊', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 14),
          Text(
            'نتيجة القلقلة ستظهر هنا',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 15,
              color: Colors.red.shade50,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'سجّل تلاوتك واضغط «تحليل»',
            style: AppTextStyles.snackbarText.copyWith(
              color: Colors.red.shade400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared shell ────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCA6486).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
