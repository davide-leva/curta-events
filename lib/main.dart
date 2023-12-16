import 'dart:ui';

import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart' as controller;
import 'package:admin/screens/lista/lista_screen.dart';
import 'package:admin/screens/main/auth_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/main/web_auth_screen.dart';
import 'package:admin/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'controllers/Config.dart';

void main() {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(MyApp());
  SyncService.init();
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBgColor,
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: kSecondaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => controller.MenuController(),
          ),
        ],
        child: ValueListenableBuilder<SocketState>(
          valueListenable: SyncService.socketState,
          builder: (context, state, _) {
            switch (state) {
              case SocketState.pending:
                return Container(
                  color: kBgColor,
                );
              case SocketState.auth:
                return AuthScreen();
              case SocketState.web_auth:
                return WebAuthScreen();
              case SocketState.connect:
                10.milliseconds.delay(() =>
                    SyncService.socketState.value = SocketState.connected);
                return Container(
                  color: kBgColor,
                );
              case SocketState.connected:
                return Config.get('userLevel') == 'pr'
                    ? Scaffold(
                        body: ListaScreen(),
                      )
                    : MainScreen();
            }
          },
        ),
      ),
    );
  }
}
