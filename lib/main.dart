import 'dart:ui';

import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart' as controller;
import 'package:admin/screens/admin/components/agora.dart';
import 'package:admin/screens/config/config_screen.dart';
import 'package:admin/screens/lista_old/lista_screen.dart';
import 'package:admin/screens/main/auth_screen.dart';
import 'package:admin/screens/main/connection_failed_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/main/splash_screen.dart';
import 'package:admin/screens/main/web_auth_screen.dart';
import 'package:admin/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'controllers/Config.dart';

void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await SyncService.init();
  runApp(MyApp());
}

class NoOverscroll extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Curta Events',
      scrollBehavior: NoOverscroll().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad
        },
        scrollbars: false,
      ),
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: kBgColor,
        primaryColor: Colors.white,
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white, decorationColor: Colors.white),
        canvasColor: kSecondaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => controller.MenuController(),
          ),
        ],
        child: ValueListenableBuilder<Connection>(
          valueListenable: SyncService.status,
          builder: (context, state, _) {
            switch (state) {
              case Connection.pending:
                return SplashScreen();
              case Connection.auth:
                return AuthScreen();
              case Connection.web_auth:
                return WebAuthScreen();
              case Connection.failed:
                return ConnectionFailedScreen();
              case Connection.connected:
                return Config.get('userLevel') == 'pr'
                    ? Scaffold(
                        body: ListaScreen(),
                      )
                    : Scaffold(
                        body: Center(
                            child: SizedBox(
                                width: 400,
                                child: Agora()))); // TODO: MainScreen();
            }
          },
        ),
      ),
    );
  }
}
