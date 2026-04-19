class ApiEndpoints {
  static const String baseUrl = 'https://waneesy.runasp.net/api/v1';

  // Auth
  static const String parentLogin = '/auth/parent/login';
  static const String childLogin = '/auth/child/login';
  static const String switchChild = '/auth/switch-child';
  static const String adminLogin = '/auth/admin/login';

  // Children
  static const String children = '/children';
  static String childById(int id) => '/children/$id';
  static String childWeeklyReport(int id) => '/children/$id/weekly-report';
  static String childActivitiesSummary(int id) => '/children/$id/activities-summary';
  static String childTopScores(int id) => '/children/$id/top-scores';
  static String childAvatar(int id) => '/children/$id/avatar';

  // Games
  static const String games = '/games';
  static String gameById(int id) => '/games/$id';
  static String gamesByCategory(String category) => '/games/category/$category';
  static String gamesByDifficulty(String level) => '/games/difficulty/$level';

  // Game Scores
  static const String gameScores = '/game-scores';
  static String gameScoreById(int id) => '/game-scores/$id';
  static String gameScoresByGame(int gameId) => '/game-scores/game/$gameId';
  static String gameScoresByChild(int childId) => '/game-scores/child/$childId';
  static String topScores(int count) => '/game-scores/top/$count';

  // Parents
  static const String parents = '/parents';
  static String parentById(int id) => '/parents/$id';
  static String parentChildren(int id) => '/parents/$id/children';

  // Stories
  static const String stories = '/stories';
  static String storyById(int id) => '/stories/$id';
  static String storiesByCategory(String category) => '/stories/category/$category';

  // Story Progress
  static const String storyProgress = '/story-progress';
  static String storyProgressById(int id) => '/story-progress/$id';
  static String storyProgressByStory(int storyId) => '/story-progress/story/$storyId';
  static String storyProgressByChild(int childId) => '/story-progress/child/$childId';

  // Task Logs
  static const String taskLogs = '/task-logs';
  static String taskLogById(int id) => '/task-logs/$id';
  static String taskLogsByTask(int taskId) => '/task-logs/task/$taskId';
  static String taskLogsByChild(int childId) => '/task-logs/child/$childId';

  // Tasks
  static const String tasks = '/tasks';
  static String taskById(int id) => '/tasks/$id';
  static String tasksByDifficulty(String level) => '/tasks/difficulty/$level';
  static String tasksByCategory(String category) => '/tasks/category/$category';

  // Videos
  static const String videos = '/videos';
  static String videoById(int id) => '/videos/$id';
  static const String topWatchedVideos = '/videos/top-watched';
  static String videosByCategory(String category) => '/videos/category/$category';
  static String videoActivities(int id) => '/videos/$id/activities';

  // Video Activities
  static const String videoActivitiesProgress = '/video-activities';
  static String videoActivityById(int id) => '/video-activities/$id';
  static String updateVideoProgress(int id) => '/video-activities/$id/update-progress';
  static String videoActivitiesByChild(int childId) => '/video-activities/child/$childId';
  static String videoProgress(int videoId) => '/video-activities/video/$videoId/progress';
}
