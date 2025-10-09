// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get favorite => 'Favorite';

  @override
  String get search => 'Search';

  @override
  String get startStation => 'Start';

  @override
  String get destinationStation => 'Destination';

  @override
  String get empty => 'Empty';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get close => 'Close';

  @override
  String get select => 'Select';

  @override
  String get expressTrainTicketOrderTitle => 'Express Train Ticket Ordering';

  @override
  String get stationNotSelectedAlertTitle => 'You must select stations';

  @override
  String get stationNotSelectedAlertDescription => 'You can\'t go next step without selecting stations!';

  @override
  String routeDescription(String startStationName, String destinationStationName) {
    return '$startStationName to $destinationStationName';
  }

  @override
  String searchResultsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results found',
      one: '1 result found',
      zero: 'No results found',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes Minutes';
  }

  @override
  String get passed => 'Passed';

  @override
  String get onTime => 'On time';

  @override
  String get recommended => 'Recommended';

  @override
  String get loading => 'Loading';

  @override
  String get fuHsing => 'Fu-Hsing Semi Express';

  @override
  String get localTrain => 'Local Train';

  @override
  String get localTrainFast => 'Fast Local Train';

  @override
  String get tzeChiangEMU3000 => 'Tze-Chiang (EMU3000)';

  @override
  String get tzeChiang => 'Tze-Chiang Limited Express';

  @override
  String get ordinaryTrain => 'Ordinary Train';

  @override
  String get chuKuangExpress => 'Chu-Kuang Express';

  @override
  String get puyumaExpress => 'Puyuma Express';

  @override
  String get tarokoExpress => 'Taroko Express';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsMaterialYouTitle => 'Material You';

  @override
  String get settingsMaterialYouDescription => 'Use System Color';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsAdvanced => 'Advanced';

  @override
  String get settingsAPIConfigurationTitle => 'API Configuration';

  @override
  String get settingsAPIConfigurationDescription => 'Modify API Configuration (Token,API URL)';

  @override
  String get settingsDebugModeTitle => 'Debug Mode';

  @override
  String get settingsDebugModeDescription => 'Debug Mode';

  @override
  String get settingsTestingDataTitle => 'Testing Data';

  @override
  String get settingsTestingDataDescription => 'This will use testing data instead of real data';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsDonateTitle => 'Donate';

  @override
  String get settingsDonateDescription => 'This project costs 200 dolla per month (6.5 credits of maimai)';

  @override
  String trainDelayedTime(int delay) {
    return '${delay}m Late';
  }

  @override
  String get tpe => 'Taipei';

  @override
  String get kee => 'Keelung';

  @override
  String get nwt => 'New Taipei';

  @override
  String get tao => 'Taoyuan';

  @override
  String get hsq => 'Hsinchu County';

  @override
  String get hsz => 'Hsinchu City';

  @override
  String get mia => 'Miaoli';

  @override
  String get txg => 'Taichung';

  @override
  String get cha => 'Changhua';

  @override
  String get nan => 'Nantou';

  @override
  String get yun => 'Yunlin';

  @override
  String get cyq => 'Chiayi County';

  @override
  String get cyi => 'Chiayi City';

  @override
  String get tnn => 'Tainan';

  @override
  String get khh => 'Kaohsiung';

  @override
  String get pif => 'Pingtung';

  @override
  String get ttt => 'Taitung';

  @override
  String get hua => 'Hualien';

  @override
  String get ila => 'Yilan';

  @override
  String get pen => 'Penghu';

  @override
  String get kin => 'Kinmen';

  @override
  String get ltt => 'Lienchiang';
}
