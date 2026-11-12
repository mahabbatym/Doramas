import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ko'),
    Locale('ru')
  ];

  /// No description provided for @m000.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get m000;

  /// No description provided for @m001.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get m001;

  /// No description provided for @m002.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get m002;

  /// No description provided for @m003.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get m003;

  /// No description provided for @m004.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get m004;

  /// No description provided for @m005.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get m005;

  /// No description provided for @m006.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get m006;

  /// No description provided for @m007.
  ///
  /// In en, this message translates to:
  /// **'Make it yours ✦'**
  String get m007;

  /// No description provided for @m008.
  ///
  /// In en, this message translates to:
  /// **'Dramas should bring you joy.'**
  String get m008;

  /// No description provided for @m009.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get m009;

  /// No description provided for @m010.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get m010;

  /// No description provided for @m011.
  ///
  /// In en, this message translates to:
  /// **'A cozy palette for the evening'**
  String get m011;

  /// No description provided for @m012.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get m012;

  /// No description provided for @m013.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications'**
  String get m013;

  /// No description provided for @m014.
  ///
  /// In en, this message translates to:
  /// **'Show spoilers'**
  String get m014;

  /// No description provided for @m015.
  ///
  /// In en, this message translates to:
  /// **'Keep plot secrets protected'**
  String get m015;

  /// No description provided for @m016.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get m016;

  /// No description provided for @m017.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get m017;

  /// No description provided for @m018.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get m018;

  /// No description provided for @m019.
  ///
  /// In en, this message translates to:
  /// **'About DoramaNest'**
  String get m019;

  /// No description provided for @m020.
  ///
  /// In en, this message translates to:
  /// **'Korean and Chinese drama collection'**
  String get m020;

  /// No description provided for @m021.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get m021;

  /// No description provided for @m022.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get m022;

  /// No description provided for @m023.
  ///
  /// In en, this message translates to:
  /// **'Your favorite dramas and reviews will stay on this device.'**
  String get m023;

  /// No description provided for @m024.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get m024;

  /// No description provided for @m025.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get m025;

  /// No description provided for @m026.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get m026;

  /// No description provided for @m027.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get m027;

  /// No description provided for @m028.
  ///
  /// In en, this message translates to:
  /// **'My reviews'**
  String get m028;

  /// No description provided for @m029.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get m029;

  /// No description provided for @m030.
  ///
  /// In en, this message translates to:
  /// **'My space'**
  String get m030;

  /// No description provided for @m031.
  ///
  /// In en, this message translates to:
  /// **'Favorite dramas'**
  String get m031;

  /// No description provided for @m032.
  ///
  /// In en, this message translates to:
  /// **'Favorite stories and bookmarks'**
  String get m032;

  /// No description provided for @m033.
  ///
  /// In en, this message translates to:
  /// **'My discussions'**
  String get m033;

  /// No description provided for @m034.
  ///
  /// In en, this message translates to:
  /// **'Reviews and comments'**
  String get m034;

  /// No description provided for @m035.
  ///
  /// In en, this message translates to:
  /// **'Notifications and privacy'**
  String get m035;

  /// No description provided for @m036.
  ///
  /// In en, this message translates to:
  /// **'Happy stories start here ✦'**
  String get m036;

  /// No description provided for @m037.
  ///
  /// In en, this message translates to:
  /// **'Your drama collection'**
  String get m037;

  /// No description provided for @m038.
  ///
  /// In en, this message translates to:
  /// **'Save stories and come back to them anytime.'**
  String get m038;

  /// No description provided for @m039.
  ///
  /// In en, this message translates to:
  /// **'Browse catalog →'**
  String get m039;

  /// No description provided for @m040.
  ///
  /// In en, this message translates to:
  /// **'To catalog →'**
  String get m040;

  /// No description provided for @m041.
  ///
  /// In en, this message translates to:
  /// **'Stories close to your heart ♡'**
  String get m041;

  /// No description provided for @m042.
  ///
  /// In en, this message translates to:
  /// **'All your favorites, always close by.'**
  String get m042;

  /// No description provided for @m043.
  ///
  /// In en, this message translates to:
  /// **'Find your\nstory ⌕'**
  String get m043;

  /// No description provided for @m044.
  ///
  /// In en, this message translates to:
  /// **'Your next favorite drama is one search away.'**
  String get m044;

  /// No description provided for @m045.
  ///
  /// In en, this message translates to:
  /// **'Title or genre...'**
  String get m045;

  /// No description provided for @m046.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get m046;

  /// No description provided for @m047.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get m047;

  /// No description provided for @m048.
  ///
  /// In en, this message translates to:
  /// **'Try another title, country, or genre.'**
  String get m048;

  /// No description provided for @m049.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get m049;

  /// No description provided for @m050.
  ///
  /// In en, this message translates to:
  /// **'Choose by\nyour mood ✧'**
  String get m050;

  /// No description provided for @m051.
  ///
  /// In en, this message translates to:
  /// **'Every story is waiting for its viewer.'**
  String get m051;

  /// No description provided for @m052.
  ///
  /// In en, this message translates to:
  /// **'Found:'**
  String get m052;

  /// No description provided for @m053.
  ///
  /// In en, this message translates to:
  /// **'No stories yet'**
  String get m053;

  /// No description provided for @m054.
  ///
  /// In en, this message translates to:
  /// **'Try choosing another category.'**
  String get m054;

  /// No description provided for @m055.
  ///
  /// In en, this message translates to:
  /// **'More stories ↘'**
  String get m055;

  /// No description provided for @m056.
  ///
  /// In en, this message translates to:
  /// **'By mood'**
  String get m056;

  /// No description provided for @m057.
  ///
  /// In en, this message translates to:
  /// **'All →'**
  String get m057;

  /// No description provided for @m058.
  ///
  /// In en, this message translates to:
  /// **'Popular stories'**
  String get m058;

  /// No description provided for @m059.
  ///
  /// In en, this message translates to:
  /// **'Your next\nlove is waiting!'**
  String get m059;

  /// No description provided for @m060.
  ///
  /// In en, this message translates to:
  /// **'Discover →'**
  String get m060;

  /// No description provided for @m061.
  ///
  /// In en, this message translates to:
  /// **'Stories bring us closer'**
  String get m061;

  /// No description provided for @m062.
  ///
  /// In en, this message translates to:
  /// **'Read reviews and share how you feel ♡'**
  String get m062;

  /// No description provided for @m063.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get m063;

  /// No description provided for @m064.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get m064;

  /// No description provided for @m065.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get m065;

  /// No description provided for @m066.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get m066;

  /// No description provided for @m067.
  ///
  /// In en, this message translates to:
  /// **'Korea'**
  String get m067;

  /// No description provided for @m068.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get m068;

  /// No description provided for @m069.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get m069;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} drama found} other{{count} dramas found}}'**
  String resultsCount(int count);

  /// No description provided for @m070.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get m070;

  /// No description provided for @m071.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get m071;

  /// No description provided for @m072.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nback!'**
  String get m072;

  /// No description provided for @m073.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your favorite stories.'**
  String get m073;

  /// No description provided for @m074.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get m074;

  /// No description provided for @m075.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get m075;

  /// No description provided for @m076.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password'**
  String get m076;

  /// No description provided for @m077.
  ///
  /// In en, this message translates to:
  /// **'Check your email address and try again'**
  String get m077;

  /// No description provided for @m078.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get m078;

  /// No description provided for @m079.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get m079;

  /// No description provided for @m080.
  ///
  /// In en, this message translates to:
  /// **'Sign in →'**
  String get m080;

  /// No description provided for @m081.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get m081;

  /// No description provided for @m082.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get m082;

  /// No description provided for @m083.
  ///
  /// In en, this message translates to:
  /// **'Your drama collection'**
  String get m083;

  /// No description provided for @m084.
  ///
  /// In en, this message translates to:
  /// **'Accept the app rules to continue'**
  String get m084;

  /// No description provided for @m085.
  ///
  /// In en, this message translates to:
  /// **'Shall we begin\nour story? ✨'**
  String get m085;

  /// No description provided for @m086.
  ///
  /// In en, this message translates to:
  /// **'Create a cozy corner for your favorite dramas.'**
  String get m086;

  /// No description provided for @m087.
  ///
  /// In en, this message translates to:
  /// **'Name or nickname'**
  String get m087;

  /// No description provided for @m088.
  ///
  /// In en, this message translates to:
  /// **'For example, dorama.mia'**
  String get m088;

  /// No description provided for @m089.
  ///
  /// In en, this message translates to:
  /// **'I agree to the app rules'**
  String get m089;

  /// No description provided for @m090.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get m090;

  /// No description provided for @m091.
  ///
  /// In en, this message translates to:
  /// **'Create account →'**
  String get m091;

  /// No description provided for @m092.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get m092;

  /// No description provided for @m093.
  ///
  /// In en, this message translates to:
  /// **'Skip ›'**
  String get m093;

  /// No description provided for @m094.
  ///
  /// In en, this message translates to:
  /// **'Your stories. Your feelings.\nYour little drama world.'**
  String get m094;

  /// No description provided for @m095.
  ///
  /// In en, this message translates to:
  /// **'Open your world →'**
  String get m095;

  /// No description provided for @m096.
  ///
  /// In en, this message translates to:
  /// **'MADE FOR STORY LOVERS'**
  String get m096;

  /// No description provided for @m097.
  ///
  /// In en, this message translates to:
  /// **'Stories you\nnever want to leave'**
  String get m097;

  /// No description provided for @m098.
  ///
  /// In en, this message translates to:
  /// **'Every drama is\na story to share'**
  String get m098;

  /// No description provided for @m099.
  ///
  /// In en, this message translates to:
  /// **'Share reviews, rate dramas, and meet fellow fans.'**
  String get m099;

  /// No description provided for @m100.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get m100;

  /// No description provided for @m101.
  ///
  /// In en, this message translates to:
  /// **'Get started ✦'**
  String get m101;

  /// No description provided for @m102.
  ///
  /// In en, this message translates to:
  /// **'Drama reviews'**
  String get m102;

  /// No description provided for @m103.
  ///
  /// In en, this message translates to:
  /// **'Stories are better when shared.'**
  String get m103;

  /// No description provided for @m104.
  ///
  /// In en, this message translates to:
  /// **'Viewer rating'**
  String get m104;

  /// No description provided for @m105.
  ///
  /// In en, this message translates to:
  /// **'+ Write a review'**
  String get m105;

  /// No description provided for @m106.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get m106;

  /// No description provided for @m107.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share how you felt.'**
  String get m107;

  /// No description provided for @m108.
  ///
  /// In en, this message translates to:
  /// **'Review actions'**
  String get m108;

  /// No description provided for @m109.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get m109;

  /// No description provided for @m110.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get m110;

  /// No description provided for @m111.
  ///
  /// In en, this message translates to:
  /// **'Spoiler hidden · Reveal →'**
  String get m111;

  /// No description provided for @m112.
  ///
  /// In en, this message translates to:
  /// **'You can edit this ✎'**
  String get m112;

  /// No description provided for @m113.
  ///
  /// In en, this message translates to:
  /// **'♡ Thanks'**
  String get m113;

  /// No description provided for @m114.
  ///
  /// In en, this message translates to:
  /// **'Delete this review?'**
  String get m114;

  /// No description provided for @m115.
  ///
  /// In en, this message translates to:
  /// **'This action can’t be undone.'**
  String get m115;

  /// No description provided for @m116.
  ///
  /// In en, this message translates to:
  /// **'Review deleted'**
  String get m116;

  /// No description provided for @m117.
  ///
  /// In en, this message translates to:
  /// **'Could not save review'**
  String get m117;

  /// No description provided for @m118.
  ///
  /// In en, this message translates to:
  /// **'New review'**
  String get m118;

  /// No description provided for @m119.
  ///
  /// In en, this message translates to:
  /// **'Edit review'**
  String get m119;

  /// No description provided for @m120.
  ///
  /// In en, this message translates to:
  /// **'Update your review ✎'**
  String get m120;

  /// No description provided for @m121.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think ✎'**
  String get m121;

  /// No description provided for @m122.
  ///
  /// In en, this message translates to:
  /// **'How did you like it?'**
  String get m122;

  /// No description provided for @m123.
  ///
  /// In en, this message translates to:
  /// **'Not for me'**
  String get m123;

  /// No description provided for @m124.
  ///
  /// In en, this message translates to:
  /// **'Could be better'**
  String get m124;

  /// No description provided for @m125.
  ///
  /// In en, this message translates to:
  /// **'Pretty good!'**
  String get m125;

  /// No description provided for @m126.
  ///
  /// In en, this message translates to:
  /// **'Really liked it'**
  String get m126;

  /// No description provided for @m127.
  ///
  /// In en, this message translates to:
  /// **'Loved it!'**
  String get m127;

  /// No description provided for @m128.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get m128;

  /// No description provided for @m129.
  ///
  /// In en, this message translates to:
  /// **'What surprised you? Which scene stayed with you?'**
  String get m129;

  /// No description provided for @m130.
  ///
  /// In en, this message translates to:
  /// **'Write at least 10 characters'**
  String get m130;

  /// No description provided for @m131.
  ///
  /// In en, this message translates to:
  /// **'Up to 1,000 characters'**
  String get m131;

  /// No description provided for @m132.
  ///
  /// In en, this message translates to:
  /// **'Contains spoilers'**
  String get m132;

  /// No description provided for @m133.
  ///
  /// In en, this message translates to:
  /// **'Hide this text from other viewers'**
  String get m133;

  /// No description provided for @m134.
  ///
  /// In en, this message translates to:
  /// **'Review posted ♡'**
  String get m134;

  /// No description provided for @m135.
  ///
  /// In en, this message translates to:
  /// **'Changes saved ♡'**
  String get m135;

  /// No description provided for @m136.
  ///
  /// In en, this message translates to:
  /// **'About this drama'**
  String get m136;

  /// No description provided for @m137.
  ///
  /// In en, this message translates to:
  /// **'Edit drama'**
  String get m137;

  /// No description provided for @m138.
  ///
  /// In en, this message translates to:
  /// **'Delete drama'**
  String get m138;

  /// No description provided for @m139.
  ///
  /// In en, this message translates to:
  /// **'Update progress'**
  String get m139;

  /// No description provided for @m140.
  ///
  /// In en, this message translates to:
  /// **'Mark episodes watched'**
  String get m140;

  /// No description provided for @m141.
  ///
  /// In en, this message translates to:
  /// **'Find episode 1 ↗'**
  String get m141;

  /// No description provided for @m142.
  ///
  /// In en, this message translates to:
  /// **'Discussion'**
  String get m142;

  /// No description provided for @m143.
  ///
  /// In en, this message translates to:
  /// **'Reviews and spoilers, thoughtfully managed'**
  String get m143;

  /// No description provided for @m144.
  ///
  /// In en, this message translates to:
  /// **'Reviews and ratings →'**
  String get m144;

  /// No description provided for @m145.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link. Try again later.'**
  String get m145;

  /// No description provided for @m146.
  ///
  /// In en, this message translates to:
  /// **'Watch progress'**
  String get m146;

  /// No description provided for @m147.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get m147;

  /// No description provided for @m148.
  ///
  /// In en, this message translates to:
  /// **'Related reviews, favorites, and progress will also be deleted.'**
  String get m148;

  /// No description provided for @m149.
  ///
  /// In en, this message translates to:
  /// **'Enter 1 to 500 episodes.'**
  String get m149;

  /// No description provided for @m150.
  ///
  /// In en, this message translates to:
  /// **'Could not save'**
  String get m150;

  /// No description provided for @m151.
  ///
  /// In en, this message translates to:
  /// **'New drama'**
  String get m151;

  /// No description provided for @m152.
  ///
  /// In en, this message translates to:
  /// **'Add a story ✧'**
  String get m152;

  /// No description provided for @m153.
  ///
  /// In en, this message translates to:
  /// **'Update the details ✎'**
  String get m153;

  /// No description provided for @m154.
  ///
  /// In en, this message translates to:
  /// **'This entry will be saved on this device.'**
  String get m154;

  /// No description provided for @m155.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get m155;

  /// No description provided for @m156.
  ///
  /// In en, this message translates to:
  /// **'Original title'**
  String get m156;

  /// No description provided for @m157.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get m157;

  /// No description provided for @m158.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get m158;

  /// No description provided for @m159.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get m159;

  /// No description provided for @m160.
  ///
  /// In en, this message translates to:
  /// **'Save to library →'**
  String get m160;

  /// No description provided for @m161.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get m161;

  /// No description provided for @m162.
  ///
  /// In en, this message translates to:
  /// **'Could not sort the catalog'**
  String get m162;

  /// No description provided for @m163.
  ///
  /// In en, this message translates to:
  /// **'Add a drama'**
  String get m163;

  /// No description provided for @m164.
  ///
  /// In en, this message translates to:
  /// **'By title'**
  String get m164;

  /// No description provided for @m165.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get m165;

  /// No description provided for @m166.
  ///
  /// In en, this message translates to:
  /// **'By rating'**
  String get m166;

  /// No description provided for @m167.
  ///
  /// In en, this message translates to:
  /// **'Continue watching'**
  String get m167;

  /// No description provided for @m168.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}! ✳'**
  String m168(String name);

  /// No description provided for @m169.
  ///
  /// In en, this message translates to:
  /// **'Could not load your local library'**
  String get m169;

  /// No description provided for @m170.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get m170;

  /// No description provided for @m171.
  ///
  /// In en, this message translates to:
  /// **'My reviews'**
  String get m171;

  /// No description provided for @m172.
  ///
  /// In en, this message translates to:
  /// **'DORAMA LOVER'**
  String get m172;

  /// No description provided for @m173.
  ///
  /// In en, this message translates to:
  /// **'DORAMANEST · YOUR COZY WORLD'**
  String get m173;

  /// No description provided for @m174.
  ///
  /// In en, this message translates to:
  /// **'♡ Favorite stories are saved on this device.'**
  String get m174;

  /// No description provided for @m175.
  ///
  /// In en, this message translates to:
  /// **'Could not update favorites'**
  String get m175;

  /// No description provided for @m176.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nback!'**
  String get m176;

  /// No description provided for @m177.
  ///
  /// In en, this message translates to:
  /// **'Check your email address and try again'**
  String get m177;

  /// No description provided for @m178.
  ///
  /// In en, this message translates to:
  /// **'Shall we begin\nour story? ✨'**
  String get m178;

  /// No description provided for @m179.
  ///
  /// In en, this message translates to:
  /// **'Your stories. Your feelings.\nYour little drama world.'**
  String get m179;

  /// No description provided for @m180.
  ///
  /// In en, this message translates to:
  /// **'Stories you\nnever want to leave'**
  String get m180;

  /// No description provided for @m181.
  ///
  /// In en, this message translates to:
  /// **'Every drama is\na story to share'**
  String get m181;

  /// No description provided for @m182.
  ///
  /// In en, this message translates to:
  /// **'Related reviews, favorites, and progress will also be deleted.'**
  String get m182;

  /// No description provided for @m183.
  ///
  /// In en, this message translates to:
  /// **'✦ EDITOR\'S PICK'**
  String get m183;

  /// No description provided for @m184.
  ///
  /// In en, this message translates to:
  /// **'Moments that stay with us.'**
  String get m184;

  /// No description provided for @m185.
  ///
  /// In en, this message translates to:
  /// **'Discover Korean and Chinese dramas in one cozy place.'**
  String get m185;

  /// No description provided for @m186.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get m186;

  /// No description provided for @m187.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get m187;

  /// No description provided for @m188.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email, for example hello@example.com'**
  String get m188;

  /// No description provided for @m189.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get m189;

  /// No description provided for @m190.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get m190;

  /// No description provided for @m191.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year'**
  String get m191;

  /// No description provided for @m192.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get m192;

  /// No description provided for @m193.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get m193;

  /// No description provided for @m194.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get m194;

  /// No description provided for @m195.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get m195;

  /// No description provided for @m196.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get m196;

  /// No description provided for @m197.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get m197;

  /// No description provided for @m198.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nback!'**
  String get m198;

  /// No description provided for @m199.
  ///
  /// In en, this message translates to:
  /// **'Shall we begin\nour story? ✨'**
  String get m199;

  /// No description provided for @m200.
  ///
  /// In en, this message translates to:
  /// **'Your stories. Your feelings.\nYour little drama world.'**
  String get m200;

  /// No description provided for @m201.
  ///
  /// In en, this message translates to:
  /// **'Stories you\nnever want to leave'**
  String get m201;

  /// No description provided for @m202.
  ///
  /// In en, this message translates to:
  /// **'Every drama is\na story to share'**
  String get m202;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}! ✳'**
  String greeting(String name);

  /// No description provided for @m203.
  ///
  /// In en, this message translates to:
  /// **'Moments that stay with us.'**
  String get m203;

  /// No description provided for @m204.
  ///
  /// In en, this message translates to:
  /// **'My review'**
  String get m204;

  /// No description provided for @m205.
  ///
  /// In en, this message translates to:
  /// **'DoramaNest community'**
  String get m205;

  /// No description provided for @m206.
  ///
  /// In en, this message translates to:
  /// **'your opinion matters.'**
  String get m206;

  /// No description provided for @m207.
  ///
  /// In en, this message translates to:
  /// **'🔒 Contains spoilers'**
  String get m207;

  /// No description provided for @m208.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get m208;

  /// No description provided for @m209.
  ///
  /// In en, this message translates to:
  /// **'Save changes →'**
  String get m209;

  /// No description provided for @m210.
  ///
  /// In en, this message translates to:
  /// **'Post review →'**
  String get m210;

  /// No description provided for @m211.
  ///
  /// In en, this message translates to:
  /// **'Open a drama and share your thoughts.'**
  String get m211;

  /// No description provided for @m212.
  ///
  /// In en, this message translates to:
  /// **'Could not open YouTube. Check your connection and settings.'**
  String get m212;

  /// No description provided for @episodeCountError.
  ///
  /// In en, this message translates to:
  /// **'Episode count must be between 0 and {total}.'**
  String episodeCountError(int total);

  /// No description provided for @progressComplete.
  ///
  /// In en, this message translates to:
  /// **'All {total} episodes watched'**
  String progressComplete(int total);

  /// No description provided for @progressNext.
  ///
  /// In en, this message translates to:
  /// **'Continue: episode {episode} of {total}'**
  String progressNext(int episode, int total);

  /// No description provided for @ratingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rate {stars} stars'**
  String ratingTooltip(int stars);

  /// No description provided for @reviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{# REVIEW} other{# REVIEWS}}'**
  String reviewCount(int count);

  /// В избранное
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get m213;

  /// Удалить из избранного
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get m214;

  /// Добавить в избранное
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get m215;

  /// Убрать из избранного
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get m216;

  /// Жанр
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get m217;

  /// Необязательно
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get m218;

  /// Например, My Lovely Runner
  ///
  /// In en, this message translates to:
  /// **'For example, My Lovely Runner'**
  String get m219;

  /// О чём эта история?
  ///
  /// In en, this message translates to:
  /// **'What is this story about?'**
  String get m220;

  /// Укажи корректный год
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year'**
  String get m221;

  /// Твоя новая
  /// любовь ждёт!
  ///
  /// In en, this message translates to:
  /// **'Your next favorite\nstory awaits!'**
  String get m222;

  /// Читай отзывы и делись эмоциями ♡
  ///
  /// In en, this message translates to:
  /// **'Read reviews and share how you feel ♡'**
  String get m223;

  /// Не удалось отсортировать каталог:
  ///
  /// In en, this message translates to:
  /// **'Could not sort the catalog:'**
  String get m225;

  /// Не удалось выполнить поиск:
  ///
  /// In en, this message translates to:
  /// **'Search failed:'**
  String get m226;

  /// Не удалось сохранить:
  ///
  /// In en, this message translates to:
  /// **'Could not save:'**
  String get m227;

  /// Не удалось сохранить избранное:
  ///
  /// In en, this message translates to:
  /// **'Could not update favorites:'**
  String get m228;

  /// Find your next favorite story in the catalog.
  ///
  /// In en, this message translates to:
  /// **'Find your next favorite story in the catalog.'**
  String get m229;

  /// Удалить дораму?
  ///
  /// In en, this message translates to:
  /// **'Delete this drama?'**
  String get m230;

  /// Твои избранные дорамы и отзывы останутся на этом устройстве.
  ///
  /// In en, this message translates to:
  /// **'Your favorites and reviews will remain on this device.'**
  String get m231;

  /// Пока нет отзывов. Открой дораму и поделись впечатлением!
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Open a drama and share your thoughts!'**
  String get m232;

  /// Stories to come back to
  ///
  /// In en, this message translates to:
  /// **'Stories to come back to'**
  String get m233;

  /// Подпишись на любимые истории
  ///
  /// In en, this message translates to:
  /// **'Follow your favorite stories'**
  String get m234;

  /// Выберите число от 0 до {total}
  ///
  /// In en, this message translates to:
  /// **'Choose a number from 0 to {total}'**
  String m235(Object total);

  /// No description provided for @episodeRange.
  ///
  /// In en, this message translates to:
  /// **'Choose a number from 0 to {total}'**
  String episodeRange(int total);

  /// Найди свою
  /// историю ⌕
  ///
  /// In en, this message translates to:
  /// **'Find your next\nfavorite story ⌕'**
  String get m237;

  /// No description provided for @watchComplete.
  ///
  /// In en, this message translates to:
  /// **'{title} · completed'**
  String watchComplete(String title);

  /// No description provided for @watchNext.
  ///
  /// In en, this message translates to:
  /// **'{title} · episode {episode}'**
  String watchNext(String title, int episode);

  /// No description provided for @continueGuest.
  ///
  /// In en, this message translates to:
  /// **'Explore as a guest'**
  String get continueGuest;

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Drama lover'**
  String get guestName;

  /// No description provided for @guestLibrary.
  ///
  /// In en, this message translates to:
  /// **'Guest library · saved on this device'**
  String get guestLibrary;

  /// No description provided for @signInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your library'**
  String get signInToSync;

  /// No description provided for @confirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account, then sign in.'**
  String get confirmEmail;

  /// No description provided for @authInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check your email and password.'**
  String get authInvalid;

  /// No description provided for @authUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email before signing in.'**
  String get authUnconfirmed;

  /// No description provided for @authRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authRateLimit;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password.'**
  String get authWeakPassword;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in. Check your connection and try again.'**
  String get authFailed;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If this address has an account, a recovery link is on its way.'**
  String get resetEmailSent;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @accountRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to publish a review.'**
  String get accountRequired;

  /// No description provided for @logoutInfo.
  ///
  /// In en, this message translates to:
  /// **'Your cloud library stays with your account. Pending changes will retry when you sign back in.'**
  String get logoutInfo;

  /// No description provided for @syncLive.
  ///
  /// In en, this message translates to:
  /// **'Library sync is live'**
  String get syncLive;

  /// No description provided for @syncConnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting to live updates…'**
  String get syncConnecting;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'Changes saved here · waiting to sync'**
  String get syncPending;

  /// No description provided for @syncBusy.
  ///
  /// In en, this message translates to:
  /// **'Syncing your library…'**
  String get syncBusy;

  /// No description provided for @cloudSetupNeeded.
  ///
  /// In en, this message translates to:
  /// **'Cloud features are not ready yet. Your saved changes will retry later.'**
  String get cloudSetupNeeded;

  /// No description provided for @dnaTitle.
  ///
  /// In en, this message translates to:
  /// **'DORAMA DNA'**
  String get dnaTitle;

  /// No description provided for @dnaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stories that fit your taste'**
  String get dnaSubtitle;

  /// No description provided for @dnaOpen.
  ///
  /// In en, this message translates to:
  /// **'Discover your match'**
  String get dnaOpen;

  /// No description provided for @dnaColdStart.
  ///
  /// In en, this message translates to:
  /// **'Choose genres or save and rate dramas to build your DNA.'**
  String get dnaColdStart;

  /// No description provided for @dnaPreferences.
  ///
  /// In en, this message translates to:
  /// **'Your favorite genres'**
  String get dnaPreferences;

  /// No description provided for @dnaMood.
  ///
  /// In en, this message translates to:
  /// **'How do you want to feel?'**
  String get dnaMood;

  /// No description provided for @dnaAnyMood.
  ///
  /// In en, this message translates to:
  /// **'Any mood'**
  String get dnaAnyMood;

  /// No description provided for @dnaRomantic.
  ///
  /// In en, this message translates to:
  /// **'Romantic'**
  String get dnaRomantic;

  /// No description provided for @dnaEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get dnaEmotional;

  /// No description provided for @dnaFunny.
  ///
  /// In en, this message translates to:
  /// **'Funny'**
  String get dnaFunny;

  /// No description provided for @dnaThriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get dnaThriller;

  /// No description provided for @dnaComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get dnaComfort;

  /// No description provided for @dnaExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get dnaExplore;

  /// No description provided for @dnaMatch.
  ///
  /// In en, this message translates to:
  /// **'{score}% match'**
  String dnaMatch(int score);

  /// No description provided for @dnaWhy.
  ///
  /// In en, this message translates to:
  /// **'Why this story?'**
  String get dnaWhy;

  /// No description provided for @dnaGenreReason.
  ///
  /// In en, this message translates to:
  /// **'Genres you enjoy: {genres}'**
  String dnaGenreReason(String genres);

  /// No description provided for @dnaLengthReason.
  ///
  /// In en, this message translates to:
  /// **'Similar episode count to stories you enjoyed'**
  String get dnaLengthReason;

  /// No description provided for @dnaMoodReason.
  ///
  /// In en, this message translates to:
  /// **'Fits the selected mood by genre'**
  String get dnaMoodReason;

  /// No description provided for @dnaDiscoveryReason.
  ///
  /// In en, this message translates to:
  /// **'A chance to explore a different part of the catalog'**
  String get dnaDiscoveryReason;

  /// No description provided for @dnaMethod.
  ///
  /// In en, this message translates to:
  /// **'Match is a similarity index, not a prediction. It combines genre affinity (70%), country preference (15%) and episode length (15%), using only available signals. Favorites, progress, ratings and dropped dramas shape it. Mood filters use genres; completed and dropped dramas are excluded.'**
  String get dnaMethod;

  /// No description provided for @dnaEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matches for this mood yet. Try another mood or explore the catalog.'**
  String get dnaEmpty;

  /// No description provided for @dnaSignals.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} preference signals'**
  String dnaSignals(int count);

  /// No description provided for @watchPlanned.
  ///
  /// In en, this message translates to:
  /// **'Plan to watch'**
  String get watchPlanned;

  /// No description provided for @watchWatching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watchWatching;

  /// No description provided for @watchCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get watchCompleted;

  /// No description provided for @watchDropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get watchDropped;

  /// No description provided for @watchStatus.
  ///
  /// In en, this message translates to:
  /// **'My watching status'**
  String get watchStatus;

  /// No description provided for @dramaMissing.
  ///
  /// In en, this message translates to:
  /// **'This drama is no longer in the catalog.'**
  String get dramaMissing;

  /// No description provided for @communityLive.
  ///
  /// In en, this message translates to:
  /// **'Live community reviews'**
  String get communityLive;

  /// No description provided for @communityRating.
  ///
  /// In en, this message translates to:
  /// **'Community rating · out of 5'**
  String get communityRating;

  /// No description provided for @noRatings.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatings;

  /// No description provided for @deleteReviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the review. Please retry.'**
  String get deleteReviewFailed;

  /// No description provided for @catalogSavedCloud.
  ///
  /// In en, this message translates to:
  /// **'Changes are saved to the shared catalog.'**
  String get catalogSavedCloud;

  /// No description provided for @genreRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get genreRomance;

  /// No description provided for @genreComedy.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get genreComedy;

  /// No description provided for @genreFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get genreFantasy;

  /// No description provided for @genreMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get genreMusic;

  /// No description provided for @genreDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get genreDrama;

  /// No description provided for @genreMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get genreMystery;

  /// No description provided for @genreFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get genreFamily;

  /// No description provided for @genreAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get genreAction;

  /// No description provided for @genreThriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get genreThriller;

  /// No description provided for @apiConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Cloud access is unavailable. You can still explore as a guest.'**
  String get apiConfiguration;

  /// No description provided for @apiOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline. Showing saved data; changes will sync after reconnection.'**
  String get apiOffline;

  /// No description provided for @apiTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please retry.'**
  String get apiTimeout;

  /// No description provided for @apiUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to continue syncing.'**
  String get apiUnauthorized;

  /// No description provided for @apiForbidden.
  ///
  /// In en, this message translates to:
  /// **'Your account does not have permission for this action.'**
  String get apiForbidden;

  /// No description provided for @apiNotFound.
  ///
  /// In en, this message translates to:
  /// **'This item or cloud feature is unavailable. Please retry later.'**
  String get apiNotFound;

  /// No description provided for @apiConflict.
  ///
  /// In en, this message translates to:
  /// **'The data changed. Refresh and try again.'**
  String get apiConflict;

  /// No description provided for @apiServer.
  ///
  /// In en, this message translates to:
  /// **'The server is unavailable. Your saved data is still here.'**
  String get apiServer;

  /// No description provided for @apiInvalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Check the entered values and try again.'**
  String get apiInvalidRequest;

  /// No description provided for @apiInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Could not read the server response. Please retry later.'**
  String get apiInvalidResponse;

  /// No description provided for @apiUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get apiUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ko', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
