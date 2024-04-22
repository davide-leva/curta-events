import 'package:admin/constants.dart';
import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/MenuController.dart' as controller;
import 'package:admin/responsive.dart';
import 'package:admin/screens/admin/admin_screen.dart';
import 'package:admin/screens/bank/bank_screen.dart';
import 'package:admin/screens/new_lista/new_lista_screen.dart';
import 'package:admin/screens/party/party_screen.dart';
import 'package:admin/screens/inventory/inventario_screen.dart';
import 'package:admin/screens/products/products_screen.dart';
import 'package:admin/screens/shifts/shifts_screen.dart';
import 'package:admin/screens/telecamera/telecamera_screen.dart';
import 'package:admin/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/Device.dart';
import '../../services/socket_service.dart';
import '../config/config_screen.dart';
import '../lista/lista_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int _screen = 0;

  List<Widget> screens = [
    DashboardScreen(),
    ListaScreen(),
    NewListaScreen(),
    InventarioScreen(),
    ProductsScreen(),
    ShiftsScreen(),
    BankScreen(),
    TelecameraScreen(),
    AdminScreen(),
    ConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    buildOnSocketEvent(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: context.read<controller.MenuController>().scaffoldKey,
      drawer: SideMenu(
        setScreen: (x) => setState((() {
          _screen = x;
        })),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  setScreen: (x) => setState((() {
                    _screen = x;
                  })),
                ),
              ),
            Expanded(
              flex: 5,
              child: screens[_screen],
            ),
          ],
        ),
      ),
    );
  }

  buildOnSocketEvent(BuildContext context) {
    SocketService.setListener(EventType.REGISTRATION, (event) {
      SocketService.setListener(EventType.AUTH, (event) {
        SyncService.answerRing();
        Config.set('key', event.data['key']);
        Device device = Device.fromJson(event.data['device']);
        Config.set('operator', device.operator);
        Config.set('place', device.place);
        Config.set('icon', device.icon.toString());
        Config.set('userLevel', device.type);
        Navigator.of(context).pop();
        SocketService.setListener(EventType.AUTH, (p0) {});
      });

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () => Future(() => false),
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Autenticazione",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                        ),
                        child: QrImageView(
                          data: event.data['regis'],
                          eyeStyle: QrEyeStyle(
                              color: Colors.white, eyeShape: QrEyeShape.square),
                          dataModuleStyle: QrDataModuleStyle(
                            color: Colors.white,
                            dataModuleShape: QrDataModuleShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => MobileScanner(
                                  onDetect: (capture) =>
                                      SocketService.parseBarcode(capture,
                                          onAdmin: (device, key) {
                                        Config.set('operator', device.operator);
                                        Config.set('place', device.place);
                                        Config.set('key', key);
                                        SyncService.answerRing();
                                        Navigator.of(context).pop();
                                      })));
                        },
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius:
                                BorderRadius.circular(kDefaultPadding),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Config.get('deviceID'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
