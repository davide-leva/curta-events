import 'package:admin/controllers/Config.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/party/components/allert.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:admin/screens/party/components/current_party_card.dart';
import 'package:admin/screens/party/components/guests_table.dart';
import 'package:admin/screens/party/components/shop_table.dart';
import 'package:admin/screens/party/components/shop_table_mobile.dart';
import 'package:admin/screens/party/components/preview.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../components/header.dart';

import 'components/info_list.dart';
import 'components/party_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Responsive(
            desktop: _desktopView(context), mobile: _mobileView(context)),
      ),
    );
  }

  Column _desktopView(BuildContext context) {
    return Column(
      children: [
        Header(
          screenTitle: "Dashboard",
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Config.get('selectedParty') == 'testparty'
                      ? Allert()
                      : CurrentPartyCard(),
                  Info(),
                  SizedBox(height: kDefaultPadding),
                  MaterialTable(),
                  SizedBox(height: kDefaultPadding),
                  GuestsList(),
                ],
              ),
            ),
            SizedBox(width: kDefaultPadding),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Preview(),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Balance(),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  PartyDetails(),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Column _mobileView(BuildContext context) {
    return Column(
      children: [
        Header(
          screenTitle: "Dashboard",
        ),
        Config.get('selectedParty') == 'testparty'
            ? Allert()
            : CurrentPartyCard(),
        Info(),
        SizedBox(height: kDefaultPadding),
        MaterialTableMobile(),
        SizedBox(height: kDefaultPadding),
        GuestsList(),
        Preview(),
        SizedBox(
          height: kDefaultPadding,
        ),
        Balance(),
        SizedBox(
          height: kDefaultPadding,
        ),
        PartyDetails(),
      ],
    );
  }
}
