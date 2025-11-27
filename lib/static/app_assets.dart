/// Centralized asset paths for the application.
/// 
/// This class provides type-safe access to all image assets used throughout
/// the app. Using constants prevents typos and makes refactoring easier.
abstract class AppAssets {
  // Private constructor to prevent instantiation
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';

  // Splash assets
  static const String splashLogo = '$_imagesPath/splash_logo.png';

  // Avatar selection assets
  static const String person1 = '$_imagesPath/person1.png';
  static const String person2 = '$_imagesPath/person2.png';
  static const String person3 = '$_imagesPath/person3.png';
  static const String person4 = '$_imagesPath/person4.png';
  static const String person5 = '$_imagesPath/person5.png';
  static const String person6 = '$_imagesPath/person6.png';
  static const String person7 = '$_imagesPath/person7.png';
  static const String person8 = '$_imagesPath/person8.png';
  static const String person9 = '$_imagesPath/person9.png';
  static const String smallIcon = '$_imagesPath/small_icon.png';

  /// Returns all avatar images as a list
  static List<String> get allAvatars => [
        person1,
        person2,
        person3,
        person4,
        person5,
        person6,
        person7,
        person8,
        person9,
      ];
}
