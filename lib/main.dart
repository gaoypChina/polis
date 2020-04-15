import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/flutter_bloc_delegate.dart';
import 'core/service/locator.dart';
import 'core/service/services.dart';
import 'model/partido_model.dart';
import 'model/politico_model.dart';
import 'widget/my_app.dart';
import 'widget/my_app_injections.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PartidoModelAdapter());
  Hive.registerAdapter(PoliticoModelAdapter());
  initLocator(await SharedPreferences.getInstance());
  Admob.initialize('ca-app-pub-5806526425473649~5721958482');
  G<CrashlyticsService>().initCrashlytics();
  FlutterError.onError = G<CrashlyticsService>().crashlytics.recordFlutterError;
  BlocSupervisor.delegate = FlutterBlocDelegate(
    analyticsService: G<AnalyticsService>(),
    performanceService: G<PerformanceService>(),
  );
  initializeDateFormatting('pt_BR', null);

  runZoned(() {
    runApp(
      MyAppInjections(
        child: MyApp(),
      ),
    );
  }, onError: G<CrashlyticsService>().crashlytics.recordError);
}
