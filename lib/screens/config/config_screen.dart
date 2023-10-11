import 'dart:convert';

import 'package:admin/models/Event.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/config/components/color_picker.dart';
import 'package:admin/screens/config/components/party_selector.dart';
import 'package:admin/screens/config/components/setting_panel.dart';
import 'package:admin/services/local_storage.dart';
import 'package:admin/services/socket_service.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/Config.dart';
import '../components/header.dart';
import 'components/party_adder.dart';

class ConfigScreen extends StatefulWidget {
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Responsive(
          mobile: _mobileView(),
          desktop: _desktopView(),
        ),
      ),
    );
  }

  Column _desktopView() {
    return Column(
      children: [
        Header(
          screenTitle: "Impostazioni",
          buttons: [
            ActionButton(
              title: "Reset",
              onPressed: LocalStorage.reset,
              icon: Icons.restore,
              color: Colors.teal,
            )
          ],
        ),
        SizedBox(height: defaultPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  PartySelector(),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  PartyAdder(),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SettingPanel(
                    settingList: [
                      'visibleParties',
                    ],
                    panelName: 'Pannello feste',
                    controllers: [
                      ColorPicker(),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: defaultPadding,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SettingPanel(settingList: [
                    'deviceID',
                    'key',
                    'dataEndpoint',
                    'socketEndpoint',
                  ], panelName: 'Connettività'),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SettingPanel(
                    settingList: [
                      'operator',
                      'place',
                      'userLevel',
                      'icon',
                    ],
                    panelName: 'Identità',
                    readOnly: true,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Column _mobileView() {
    return Column(
      children: [
        Header(
          screenTitle: "Impostazioni",
          buttons: [
            ActionButton(
              title: "Reset",
              onPressed: LocalStorage.reset,
              icon: Icons.restore,
              color: Colors.teal,
            )
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        PartySelector(),
        SizedBox(
          height: defaultPadding,
        ),
        PartyAdder(),
        SizedBox(
          height: defaultPadding,
        ),
        SettingPanel(
          settingList: [
            'visibleParties',
          ],
          panelName: 'Pannello feste',
          controllers: [
            ColorPicker(),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        SettingPanel(settingList: [
          'deviceID',
          'key',
          'dataEndpoint',
          'socketEndpoint',
        ], panelName: 'Connettività'),
        SizedBox(
          height: defaultPadding,
        ),
        SettingPanel(
          settingList: [
            'operator',
            'place',
            'userLevel',
            'icon',
          ],
          panelName: 'Identità',
          readOnly: true,
        ),
      ],
    );
  }
}
