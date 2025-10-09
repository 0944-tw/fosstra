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
  String get passed => '已過站';

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
  String get settingsGeneral => '一般';

  @override
  String get settingsMaterialYouTitle => 'Material You';

  @override
  String get settingsMaterialYouDescription => '使用系統色彩';

  @override
  String get settingsLanguageTitle => '語言';

  @override
  String get settingsAdvanced => '進階';

  @override
  String get settingsAPIConfigurationTitle => 'API 設定';

  @override
  String get settingsAPIConfigurationDescription => '修改 API 設定 (Token, API URL)';

  @override
  String get settingsDebugModeTitle => '偵錯模式';

  @override
  String get settingsDebugModeDescription => '偵錯模式';

  @override
  String get settingsTestingDataTitle => '測試資料';

  @override
  String get settingsTestingDataDescription => '這將會使用測試資料而非真實資料';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsVersionTitle => '版本';

  @override
  String get settingsDonateTitle => '贊助';

  @override
  String get settingsDonateDescription => '這個專案每月花費 200 美元 (6.5 道 maimai)';

  @override
  String trainDelayedTime(int delay) {
    return '晚$delay分';
  }

  @override
  String get tpe => '臺北市';

  @override
  String get kee => '基隆市';

  @override
  String get nwt => '新北市';

  @override
  String get tao => '桃園市';

  @override
  String get hsq => '新竹縣';

  @override
  String get hsz => '新竹市';

  @override
  String get mia => '苗栗縣';

  @override
  String get txg => '臺中市';

  @override
  String get cha => '彰化縣';

  @override
  String get nan => '南投縣';

  @override
  String get yun => '雲林縣';

  @override
  String get cyq => '嘉義縣';

  @override
  String get cyi => '嘉義市';

  @override
  String get tnn => '臺南市';

  @override
  String get khh => '高雄市';

  @override
  String get pif => '屏東縣';

  @override
  String get ttt => '臺東縣';

  @override
  String get hua => '花蓮縣';

  @override
  String get ila => '宜蘭縣';

  @override
  String get pen => '澎湖縣';

  @override
  String get kin => '金門縣';

  @override
  String get ltt => '連江縣';
}
