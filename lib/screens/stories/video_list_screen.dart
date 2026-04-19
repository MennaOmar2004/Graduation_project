import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/blocs/stories/bloc.dart';
import 'package:wanisi_app/blocs/stories/repository.dart';
import 'package:wanisi_app/blocs/stories/state.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/models/story.dart';
import 'package:wanisi_app/screens/stories/video_player_screen.dart';

class VideoListScreen extends StatefulWidget {
  final String category;

  const VideoListScreen({super.key, required this.category});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
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
                  _buildVideoList(state.stories.where((s) => s.videoUrl != null).toList())
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
    Color themeColor = _getCategoryColor();
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      elevation: 0,
      backgroundColor: themeColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'فيديوهات ${widget.category}',
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -30,
              child: Icon(Icons.play_circle_fill_rounded, 
                size: 200, 
                color: Colors.white.withValues(alpha: 0.1)
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
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _VideoCard(story: stories[index]),
          childCount: stories.length,
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    if (widget.category.contains('تربوية')) return AppColors.purple;
    if (widget.category.contains('دينية')) return AppColors.blue;
    return AppColors.green;
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
            color: story.uiColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerScreen(story: story)),
        ),
        borderRadius: BorderRadius.circular(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail with Play Button Overlay
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      story.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: story.uiColor.withValues(alpha: 0.1),
                        child: Icon(Icons.image_not_supported_rounded, color: story.uiColor),
                      ),
                    ),
                  ),
                ),
                // Glassmorphism Play Button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.3),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                ),
              ],
            ),
            // Information Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    story.title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              '+${story.points}',
                              style: GoogleFonts.fredoka(
                                color: const Color(0xFFB8860B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'شاهد الآن',
                            style: GoogleFonts.cairo(
                              color: story.uiColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.video_collection_rounded, size: 18, color: story.uiColor),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
