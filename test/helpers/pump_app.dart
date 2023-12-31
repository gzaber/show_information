import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockInformationRepository extends Mock implements InformationRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    InformationRepository? informationRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: informationRepository ?? MockInformationRepository(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  Future<void> pumpRoute(
    Route<dynamic> route, {
    InformationRepository? informationRepository,
  }) {
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
      informationRepository: informationRepository,
    );
  }

  Future<void> pumpToPop(
    Widget widget,
  ) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => widget),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    await tap(find.byType(FloatingActionButton));
    await pumpAndSettle();
  }

  Future<void> dragSlidable(Finder finder, Offset offset) async {
    final gesture = await startGesture(getTopLeft(finder));
    await gesture.moveBy(offset);
    await gesture.cancel();
    await pump();
  }
}
