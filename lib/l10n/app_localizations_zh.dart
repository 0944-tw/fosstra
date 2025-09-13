// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => '首頁';

  @override
  String get history => '歷史紀錄';

  @override
  String get favorite => '最愛';

  @override
  String get search => '搜尋';

  @override
  String get startStation => '起點';

  @override
  String get destinationStation => '終點';

  @override
  String get empty => '空';

  @override
  String get date => '日期';

  @override
  String get time => '時間';

  @override
  String get close => '關閉';

  @override
  String get select => '選擇';

  @override
  String get expressTrainTicketOrderTitle => '對號列車訂票';

  @override
  String get stationNotSelectedAlertTitle => '必須選擇車站';

  @override
  String get stationNotSelectedAlertDescription => '未選擇車站無法進入下一步！';

  @override
  String routeDescription(String startStationName, String destinationStationName) {
    return '$startStationName 前往 $destinationStationName';
  }

  @override
  String searchResultsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 筆結果',
      one: '找到 1 筆結果',
      zero: '沒有找到結果',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get passed => '已通過';

  @override
  String get onTime => '準點';

  @override
  String get recommended => '推薦';

  @override
  String get loading => '載入中';

  @override
  String get fuHsing => '復興號';

  @override
  String get localTrain => '區間車';

  @override
  String get localTrainFast => '區間快車';

  @override
  String get tzeChiangEMU3000 => '自強號 (EMU3000)';

  @override
  String get tzeChiang => '自強號';

  @override
  String get ordinaryTrain => '普快車';

  @override
  String get chuKuangExpress => '莒光號';

  @override
  String get puyumaExpress => '普悠瑪號';

  @override
  String get tarokoExpress => '太魯閣號';

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
}
