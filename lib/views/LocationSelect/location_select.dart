// location_select_view.dart

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/LocationSelect/location_select_viewmodel.dart';

class LocationSelectView extends StatelessWidget {
  final String title;

  const LocationSelectView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);

    return ViewModelBuilder<LocationSelectViewModel>.reactive(
      viewModelBuilder: () => LocationSelectViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(localizations.select)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        body: model.isBusy
            ? const Center(child: CircularProgressIndicator())
            : Row(
          children: [
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: model.cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(model.cities[index].key),
                    onTap: () {
                      model.selectCity(index);
                    },
                  );
                },
              ),
            ),
            //
            const VerticalDivider(width: 1.0),
            //
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: model.selectedStations.length,
                itemBuilder: (context, index) {
                  final station = model.selectedStations[index];
                  return ListTile(
                    title: Text(model.getLocalizedStationName(station, loc)),
                    onTap: () {
                      model.stationSelected(context,station);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}