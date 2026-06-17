import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          // Reload scores and tasks for the newly selected child
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
        body: Column(
          children: [
            // 1. الجزء العلوي البنفسجي (Header)
            _buildHeader(),

            // 2. قائمة الأطفال
            Expanded(
              child: BlocBuilder<ChildCubit, ChildState>(
                builder: (context, state) {
                  if (state is InitialChildState) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF0900FF)),
                    );
                  }

                  if (state is LoadChildFailed) {
                    return Center(child: Text(state.error));
                  }

                  if (state is LoadChild) {
                    final children = state.childrenList;

                    if (children.isEmpty) {
                      return const Center(child: Text("لا يوجد أطفال مضافين"));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: children.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final child = children[index];
                        return _buildChildCard(context, child);
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت الجزء العلوي
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        color: Color(0xFF91D6F0), // البنفسجي الغامق
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            "قائمة الاطفال",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ودجت بطاقة الطفل في القائمة
  Widget _buildChildCard(BuildContext context, Child child) {
    return InkWell(
      onTap: () => showStyledPinDialog(context, child),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFEDE2D), // الهالة الصفراء من Figma
                    blurRadius: 12,
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(child.avatarUrl),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B0033),
                    ),
                  ),
                  Text(
                    "العمر: ${child.age}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// الديالوج المصمم (Styled Dialog)
// --------------------------------------------------------------------------
void showStyledPinDialog(BuildContext context, Child child) {
  final pinController = TextEditingController();

  String? errorText;
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return BlocListener<ChildCubit, ChildState>(
            listener: (context, state) {
              if (state is ChildSelectedSuccess) {
                // Reload scores and tasks for the newly selected child
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
                  errorText = "الرقم السري غير صحيح";
                });
              }
            },
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F9FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "ادخل الرقم السري",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B0033),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: pinController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            letterSpacing: 8,
                          ),
                          decoration: InputDecoration(
                            hintText: "••••",
                            errorText: errorText,
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text(
                                  "إلغاء",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _buildPrimaryButton(
                                text: isLoading ? "..." : "دخول",
                                onPressed: () {
                                  final pin = pinController.text.trim();

                                  if (pin.isEmpty) {
                                    setState(() {
                                      errorText = "من فضلك أدخل الرقم السري";
                                    });
                                    return;
                                  }

                                  setState(() {
                                    errorText = null;
                                    isLoading = true;
                                  });

                                  context.read<ChildCubit>().selectChild(
                                    child,
                                    pin,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -40,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFFFEDE2D),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(child.avatarUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// زر مخصص بـ Hard Shadow كما في Figma
Widget _buildPrimaryButton({required String text, required VoidCallback onPressed}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Color(0xFFC0C0C0), // ظل صلب أزرق غامق
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0900FF),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}