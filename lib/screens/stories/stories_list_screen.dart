import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/blocs/stories/bloc.dart';
import 'package:wanisi_app/blocs/stories/repository.dart';
import 'package:wanisi_app/blocs/stories/state.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/models/story.dart';
import 'package:wanisi_app/screens/stories/story_view_screen.dart';

class StoriesListScreen extends StatefulWidget {
  final String category;

  const StoriesListScreen({super.key, required this.category});

  @override
  State<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends State<StoriesListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoriesCubit(StoriesRepository())..fetchStoriesByCategory(widget.category),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFDFF),
        body: BlocBuilder<StoriesCubit, StoriesState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context),
                if (state is StoriesLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is StoriesError)
                  SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  )
                else if (state is StoriesLoaded)
                  _buildStoriesList(state.stories)
                else
                  const SliverFillRemaining(child: SizedBox()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.blue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        _buildPointsBadge(),
        const SizedBox(width: 15),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.category,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.blue, AppColors.blue_],
                ),
              ),
            ),
            // Abstract decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const SizedBox(height: 20),
                   Image.asset(
                    'assets/images/small_icon.png',
                    height: 80,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/star.png', width: 14),
          const SizedBox(width: 6),
          Text(
            '70',
            style: GoogleFonts.fredoka(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(List<Story> stories) {
    if (stories.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('لا توجد قصص حالياً')),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final story = stories[index];
            return _StoryCard(story: story, index: index);
          },
          childCount: stories.length,
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Story story;
  final int index;

  const _StoryCard({required this.story, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 600),
                    pageBuilder: (context, anim, _) => FadeTransition(
                      opacity: anim,
                      child: StoryViewScreen(story: story),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'story_${story.id}',
                          child: Container(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              color: _getCategoryColor().withOpacity(0.12),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.menu_book_rounded,
                                color: AppColors.blue, size: 35),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.text,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildCardMetadata(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCardFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    if (story.category.contains('تربوية')) return AppColors.purple;
    if (story.category.contains('دينية')) return AppColors.blue;
    return AppColors.green;
  }

  Widget _buildCardMetadata() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(
                '${story.points} نقطة',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '5 دقائق', // Sample duration
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.03),
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ابدأ المغامرة الآن',
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.blue),
        ],
      ),
    );
  }
}
