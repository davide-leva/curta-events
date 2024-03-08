import 'package:admin/responsive.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/config/components/color_picker.dart';
import 'package:admin/screens/config/components/party_selector.dart';
import 'package:admin/screens/config/components/setting_panel.dart';
import 'package:admin/services/local_storage.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
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
        padding: EdgeInsets.all(kDefaultPadding),
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
        SizedBox(height: kDefaultPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  PartySelector(),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  PartyAdder(),
                  SizedBox(
                    height: kDefaultPadding,
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
              width: kDefaultPadding,
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
                    height: kDefaultPadding,
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
          height: kDefaultPadding,
        ),
        PartySelector(),
        SizedBox(
          height: kDefaultPadding,
        ),
        PartyAdder(),
        SizedBox(
          height: kDefaultPadding,
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
          height: kDefaultPadding,
        ),
        SettingPanel(settingList: [
          'deviceID',
          'key',
          'dataEndpoint',
          'socketEndpoint',
        ], panelName: 'Connettività'),
        SizedBox(
          height: kDefaultPadding,
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
