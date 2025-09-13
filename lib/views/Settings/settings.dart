import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/LocationSelect/location_select.dart';
import 'package:tra/views/Settings/settings_viewmodel.dart';
import 'package:tra/views/TRA_SearchPage/TRA_SearchPage.dart';



class SettingsIndex extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const Map<String, String> languageMap = {
      'en': 'English',
      'es': 'Español', // Spanish
      'fr': 'Français', // French
      'de': 'Deutsch', // German
      'it': 'Italiano', // Italian
      'ja': '日本語', // Japanese
      'ko': '한국어', // Korean
      'zh': '中文', // Chinese
      'hi': 'हिन्दी', // Hindi
      'ar': 'العربية', // Arabic
      'pt': 'Português', // Portuguese
    };

    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onViewModelReady: (model) => model.init(context),
      builder: (context, model, child) =>    SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    localizations.settingsGeneral,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.brush_rounded,
                          weight: 600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),

                        title: Text(localizations.settingsMaterialYouTitle),
                        subtitle: Text(localizations.settingsMaterialYouDescription),
                        onTap: () {
                          model.setEnableMaterialYou(!model.enableMaterialYou);
                        },
                        trailing: Switch(
                          // This bool value toggles the switch.
                          value: model.enableMaterialYou,
                          onChanged: (bool value) async {
                            model.setEnableMaterialYou(
                              !model.enableMaterialYou,
                            );
                          },
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.translate_rounded,
                          weight: 600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(localizations.settingsLanguageTitle),
                        subtitle: Text(languageMap[model.locale.languageCode]!),
                        onTap: () async {
                          await context.push("/settings/locale");
                          model.init(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    localizations.settingsAdvanced,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14.0,
                    ),
                  ),
                ),

                Material(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.link, weight: 600),
                        iconColor: Theme.of(context).colorScheme.secondary,

                        title: Text(localizations.settingsAPIConfigurationTitle),
                        subtitle: Text(localizations.settingsAPIConfigurationDescription),
                        onTap: () {},
                      ),

                      Divider(height: 1),
                      ListTile(
                        title: Text(localizations.settingsDebugModeTitle),
                        subtitle: Text(localizations.settingsDebugModeDescription),
                        iconColor: Theme.of(context).colorScheme.secondary,

                        leading: Icon(Icons.bug_report_rounded, weight: 600),
                        onTap: () {},
                        trailing: Switch(
                          // This bool value toggles the switch.
                          value: model.debugMode,
                          onChanged: (bool value) async {
                            model.setDebugMode(!model.debugMode);
                          },
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text("Reset Data"),
                        subtitle: Text("Something went wrong? Click here to reset data"),
                        iconColor: Theme.of(context).colorScheme.secondary,

                        leading: Icon(Symbols.delete, weight: 600),
                        onTap: () {
                         model.resetData();
                        },

                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text(localizations.settingsTestingDataTitle),
                        subtitle: Text(localizations.settingsTestingDataDescription),
                        iconColor: Theme.of(context).colorScheme.secondary,
                        leading: Icon(Icons.data_object_rounded, weight: 600),
                        onTap: () {},
                        trailing: Switch(
                          // This bool value toggles the switch.
                          value: model.useTestData,
                          onChanged: (bool value) async {
                            model.setUseTestData(!model.useTestData);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    localizations.settingsAbout,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14.0,
                    ),
                  ),
                ),

                Material(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(localizations.settingsVersionTitle),
                        subtitle: Text("v0.0.1-114514"),
                        iconColor: Theme.of(context).colorScheme.secondary,
                        leading: Icon(Icons.info_rounded, weight: 600),
                        onTap: () {},
                      ),
                      Divider(height: 1),

                      ListTile(
                        title: Text(localizations.settingsDonateTitle),
                        leading: Icon(Icons.favorite_rounded),
                        iconColor: Theme.of(context).colorScheme.secondary,
                        subtitle: Text(localizations.settingsDonateDescription),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3),
              ],
            ),

      ),
    );
  }
}
