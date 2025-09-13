import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/Settings/locale/viewmodel.dart';

class SettingsLocalePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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

    final localizations = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    List<Locale> localeList = AppLocalizations.supportedLocales;
    return ViewModelBuilder<SettingsLocalePageViewModel>.reactive(
      viewModelBuilder: () => SettingsLocalePageViewModel(),
      onViewModelReady: (model) => model.init(context),
      builder: (context, model, child) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),

        child: Column(
          children: [
            Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      "Current Language",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(languageMap[model.locale.languageCode] ?? ""),
                    textColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Material(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < localeList.length; i++)
                    Builder(
                        builder: (context) {
                          final item = localeList[i];
                          final isLastItem = i == localeList.length - 1;

                          return Column(
                            children: [
                              ListTile(
                                title: Text(languageMap[item.languageCode] ?? "Unknown"),
                                trailing: model.locale.toString() == item.toString() ? Icon(Symbols.check_rounded, weight: 300) : null,
                                onTap: () {
                                 model.updateLocale(item);
                                  context.pop();
                                },
                              ),
                              if (!isLastItem)
                                Padding(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: Divider(height: 0.25),
                                ),
                            ],
                          );
                        }
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
