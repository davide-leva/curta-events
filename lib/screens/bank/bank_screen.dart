import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/bank/components/actual_balance.dart';
import 'package:admin/screens/bank/components/bank_summary.dart';
import 'package:admin/screens/bank/components/transaction_table.dart';
import 'package:admin/screens/components/header.dart';
import 'package:flutter/material.dart';

class BankScreen extends StatelessWidget {
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
        Header(screenTitle: "Cassa"),
        SizedBox(
          height: kDefaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 13,
              child: TransactionTable(),
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  ActualBalance(),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  BankSummary(),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Column _mobileView() {
    return Column(
      children: [
        Header(screenTitle: "Cassa"),
        ActualBalance(),
        SizedBox(
          height: kDefaultPadding,
        ),
        TransactionTable(),
        SizedBox(
          height: kDefaultPadding,
        ),
        BankSummary(),
      ],
    );
  }
}
