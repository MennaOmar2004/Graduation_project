import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/widgets/avatar_circle.dart';
import 'package:wanisi_app/widgets/back_ground_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_html/flutter_html.dart';
import 'settings_screen.dart';
import 'avatar_selection_screen/widgets/layered_button.dart';

class TajweedAnalyzerScreen extends StatefulWidget {
  const TajweedAnalyzerScreen({super.key});

  @override
  State<TajweedAnalyzerScreen> createState() => _TajweedAnalyzerScreenState();
}

class _TajweedAnalyzerScreenState extends State<TajweedAnalyzerScreen> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TajweedCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const BackGroundWidget(),
              Column(
                children: [
                  const SizedBox(height: 16),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                          color: AppColors.blue_,
                        ),
                        AvatarCircle(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        Text(
                          'مصحف التجويد الذكي',
                          style: AppTextStyles.linkText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Main Body
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'اكتبي الآية للبحث عنها أو استخدمي الميكروفون',
                              style: AppTextStyles.linkText.copyWith(fontSize: 16),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      hintText: 'مثال: قل هو الله أحد',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: _listen,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _isListening
                                          ? Colors.red.withValues(alpha: 0.08)
                                          : Colors.white,
                                      border: Border.all(
                                        color: _isListening
                                            ? Colors.redAccent
                                            : Colors.grey.shade300,
                                        width: _isListening ? 3 : 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _isListening
                                              ? Colors.red.withValues(alpha: 0.5)
                                              : Colors.black.withValues(alpha: 0.05),
                                          blurRadius: _isListening ? 16 : 6,
                                          spreadRadius: _isListening ? 3 : 1,
                                          offset: _isListening
                                              ? const Offset(0, 0)
                                              : const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200),
                                      opacity: _isListening ? 1.0 : 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          'assets/images/recorder.png',
                                          width: 52,
                                          height: 52,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) => CircleAvatar(
                                            backgroundColor: _isListening ? Colors.red : AppColors.blue,
                                            child: Icon(
                                              _isListening ? Icons.mic : Icons.mic_none,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            Builder(
                               builder: (context) {
                                 return LayeredButton(
                                   text: 'تحليل التجويد',
                                   backgroundColor: const Color(0xFFFCBAD3),
                                   shadowColor: const Color(0xFFD98399),
                                   width: double.infinity,
                                   height: 55,
                                   onPressed: () {
                                     context.read<TajweedCubit>().analyzeAyah(_controller.text);
                                   },
                                 );
                               }
                             ),
                            const SizedBox(height: 30),
                            
                            // Result Area
                            BlocBuilder<TajweedCubit, TajweedState>(
                              builder: (context, state) {
                                if (state is TajweedLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is TajweedFailureState) {
                                  return Text(
                                    state.message,
                                    style: const TextStyle(color: Colors.red, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  );
                                } else if (state is TajweedSuccessState) {
                                  return Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withValues(alpha: 0.2),
                                          blurRadius: 10,
                                        )
                                      ],
                                    ),
                                    child: Html(
                                      data: state.htmlContent,
                                      style: {
                                        "body": Style(
                                          textAlign: TextAlign.center,
                                          fontSize: FontSize(24),
                                          fontFamily: 'Amiri', // Or any appropriate Arabic font
                                        ),
                                      },
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
