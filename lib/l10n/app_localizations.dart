import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @startStation.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startStation;

  /// No description provided for @destinationStation.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destinationStation;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @expressTrainTicketOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Express Train Ticket Ordering'**
  String get expressTrainTicketOrderTitle;

  /// No description provided for @stationNotSelectedAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'You must select stations'**
  String get stationNotSelectedAlertTitle;

  /// No description provided for @stationNotSelectedAlertDescription.
  ///
  /// In en, this message translates to:
  /// **'You can\'t go next step without selecting stations!'**
  String get stationNotSelectedAlertDescription;

  /// Describes a route from a starting station to a destination station.
  ///
  /// In en, this message translates to:
  /// **'{startStationName} to {destinationStationName}'**
  String routeDescription(String startStationName, String destinationStationName);

  /// Indicates how many search results were found.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results found} =1{1 result found} other{{count} results found}}'**
  String searchResultsFound(int count);

  /// The time the train costs
  ///
  /// In en, this message translates to:
  /// **'{minutes} Minutes'**
  String durationMinutes(int minutes);

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get onTime;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @fuHsing.
  ///
  /// In en, this message translates to:
  /// **'Fu-Hsing Semi Express'**
  String get fuHsing;

  /// No description provided for @localTrain.
  ///
  /// In en, this message translates to:
  /// **'Local Train'**
  String get localTrain;

  /// No description provided for @localTrainFast.
  ///
  /// In en, this message translates to:
  /// **'Fast Local Train'**
  String get localTrainFast;

  /// No description provided for @tzeChiangEMU3000.
  ///
  /// In en, this message translates to:
  /// **'Tze-Chiang (EMU3000)'**
  String get tzeChiangEMU3000;

  /// No description provided for @tzeChiang.
  ///
  /// In en, this message translates to:
  /// **'Tze-Chiang Limited Express'**
  String get tzeChiang;

  /// No description provided for @ordinaryTrain.
  ///
  /// In en, this message translates to:
  /// **'Ordinary Train'**
  String get ordinaryTrain;

  /// No description provided for @chuKuangExpress.
  ///
  /// In en, this message translates to:
  /// **'Chu-Kuang Express'**
  String get chuKuangExpress;

  /// No description provided for @puyumaExpress.
  ///
  /// In en, this message translates to:
  /// **'Puyuma Express'**
  String get puyumaExpress;

  /// No description provided for @tarokoExpress.
  ///
  /// In en, this message translates to:
  /// **'Taroko Express'**
  String get tarokoExpress;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsMaterialYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Material You'**
  String get settingsMaterialYouTitle;

  /// No description provided for @settingsMaterialYouDescription.
  ///
  /// In en, this message translates to:
  /// **'Use System Color'**
  String get settingsMaterialYouDescription;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsAdvanced;

  /// No description provided for @settingsAPIConfigurationTitle.
  ///
  /// In en, this message translates to:
  /// **'API Configuration'**
  String get settingsAPIConfigurationTitle;

  /// No description provided for @settingsAPIConfigurationDescription.
  ///
  /// In en, this message translates to:
  /// **'Modify API Configuration (Token,API URL)'**
  String get settingsAPIConfigurationDescription;

  /// No description provided for @settingsDebugModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get settingsDebugModeTitle;

  /// No description provided for @settingsDebugModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get settingsDebugModeDescription;

  /// No description provided for @settingsTestingDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Testing Data'**
  String get settingsTestingDataTitle;

  /// No description provided for @settingsTestingDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will use testing data instead of real data'**
  String get settingsTestingDataDescription;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionTitle;

  /// No description provided for @settingsDonateTitle.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get settingsDonateTitle;

  /// No description provided for @settingsDonateDescription.
  ///
  /// In en, this message translates to:
  /// **'This project costs 200 dolla per month (6.5 credits of maimai)'**
  String get settingsDonateDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
