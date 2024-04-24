import 'package:admin/constants.dart';
import 'package:admin/screens/components/badge.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:admin/services/call_service.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:flutter/material.dart';

class Agora extends StatelessWidget {
  const Agora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(kDefaultPadding),
      ),
      child: Column(
        children: [
          GestureDetector(
              onTap: () async {
                await CallService.leave();
                CallService.join("membri");
              },
              child: border(Column(
                children: [
                  InfoBadge(
                    color: Colors.lightBlue,
                    text: "Membri",
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                ],
              ))),
          SizedBox(
            height: kDefaultPadding,
          ),
          GestureDetector(
            onTap: () async {
              await CallService.leave();
              CallService.join("security");
            },
            child: InfoBadge(
              color: Colors.lightBlue,
              text: "Security",
            ),
          )
        ],
      ),
    );
  }
}
