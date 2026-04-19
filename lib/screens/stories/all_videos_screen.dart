import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/blocs/stories/bloc.dart';
import 'package:wanisi_app/blocs/stories/repository.dart';
import 'package:wanisi_app/blocs/stories/state.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/models/story.dart';
import 'package:wanisi_app/screens/stories/video_player_screen.dart';

class AllVideosScreen extends StatefulWidget {
  const AllVideosScreen({super.key});

  @override
  State<AllVideosScreen> createState() => _AllVideosScreenState();
}

class _AllVideosScreenState extends State<AllVideosScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoriesCubit(StoriesRepository())..fetchStories(),
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
                  SliverFillRemaining(child: Center(child: Text(state.message)))
                else if (state is StoriesLoaded)
                  _buildVideoList(
                    state.stories.where((s) => s.videoUrl != null).toList(),
                  )
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
    const themeColor = Color(0xFFFF6EC7); // Primary theme for all videos
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      elevation: 0,
      backgroundColor: Color(0xFFFF6EC7),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'مكتبة الفيديوهات',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                ),
              ),
            ),
            // Decorative play icons
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              left: 40,
              bottom: 40,
              child: Icon(
                Icons.videocam_rounded,
                size: 60,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            // Floating particles or highlight
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Icon(
                  Icons.video_library_rounded,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList(List<Story> stories) {
    if (stories.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('لا توجد فيديوهات حالياً')),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _VideoCard(story: stories[index]),
          childCount: stories.length,
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Story story;

  const _VideoCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: story.uiColor.withValues(alpha: 0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(story: story),
              ),
            ),
        borderRadius: BorderRadius.circular(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      story.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: story.uiColor.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: story.uiColor,
                            ),
                          ),
                    ),
                  ),
                ),
                // Premium Play Overlay
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.3),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                // Category Tag
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: story.uiColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      story.category,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    story.title,
                    style: GoogleFonts.cairo(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildPointsBadge(), _buildWatchNowAction()],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, color: Color(0xFFD4AF37), size: 18),
          const SizedBox(width: 6),
          Text(
            '+${story.points}',
            style: GoogleFonts.fredoka(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchNowAction() {
    return Row(
      children: [
        Text(
          'شاهد الآن',
          style: GoogleFonts.cairo(
            color: story.uiColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.video_library_rounded, size: 20, color: story.uiColor),
      ],
    );
  }
}
