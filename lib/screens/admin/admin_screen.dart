import 'package:admin/constants.dart';
import 'package:admin/models/Device.dart';
import 'package:admin/models/Event.dart';
import 'package:admin/screens/admin/components/devices_card.dart';
import 'package:admin/screens/admin/components/icon_selector.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/screens/config/components/setting_panel.dart';
import 'package:admin/services/socket_service.dart';
import 'package:admin/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../controllers/Config.dart';
import '../components/header.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _operatorController = TextEditingController();
    TextEditingController _placeController = TextEditingController();

    String _type = "Pr";
    IconData _icon = Icons.phone_android;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              screenTitle: "Pannello admin",
              buttons: [
                TableButton(
                    color: Colors.lightBlue,
                    icon: Icons.qr_code,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => MobileScanner(
                          overlay: Column(
                            children: [
                              SizedBox(
                                height: defaultPadding * 2,
                              ),
                              Container(
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius:
                                      BorderRadius.circular(defaultPadding),
                                ),
                                child: Text(
                                  "Scansiona codice autenticativo",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                          onDetect: (capture) {
                            SocketService.parseBarcode(capture,
                                onRegis: (code) {
                              Navigator.of(context).pop();

                              showPopUp(
                                context,
                                "Autentica dispositivo",
                                [
                                  TextInput(
                                    textController: _operatorController,
                                    label: "Operatore",
                                  ),
                                  TextInput(
                                      textController: _placeController,
                                      label: "Postazione"),
                                  Container(
                                    width: 300,
                                    padding:
                                        EdgeInsets.only(left: defaultPadding),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownMenu<String>(
                                      width: 240,
                                      hintText: "Tipo",
                                      menuHeight: 300,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        border: InputBorder.none,
                                        fillColor: Theme.of(context).cardColor,
                                      ),
                                      dropdownMenuEntries: [
                                        "Pr",
                                        "Member",
                                        "Admin"
                                      ]
                                          .map<DropdownMenuEntry<String>>(
                                            (type) => DropdownMenuEntry<String>(
                                              value: type.toLowerCase(),
                                              label: type,
                                            ),
                                          )
                                          .toList(),
                                      onSelected: (value) {
                                        setState(() {
                                          _type = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                  IconSelector(
                                    onChange: (icon) => _icon = icon,
                                  ),
                                ],
                                () => SocketService.auth(
                                  code,
                                  new Device(
                                    id: Config.get('deviceID'),
                                    operator: _operatorController.text,
                                    place: _placeController.text,
                                    type: _type,
                                    icon: _icon,
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      );
                    }),
              ],
            ),
            SizedBox(
              height: defaultPadding,
            ),
            DevicesCard(),
            SizedBox(
              height: defaultPadding,
            ),
            SettingPanel(
              settingList: [
                'cameras',
              ],
              panelName: "Telecamere",
              onSave: (p) {
                SocketService.send(
                  SocketEvent(
                    from: Config.get('deviceID'),
                    to: 'all',
                    type: EventType.SETTING,
                    data: {
                      'key': 'cameras',
                      'value': p[0],
                    },
                  ),
                );
                Config.set('cameras', p[0]);
              },
            ),
          ],
        ),
      ),
    );
  }
}