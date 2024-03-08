import 'package:admin/constants.dart';
import 'package:admin/controllers/GroupsController.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/clock_card.dart';
import 'components/devices_card.dart';
import 'components/people_card.dart';
import 'components/shifts_card.dart';

class ViewerScreen extends StatefulWidget {
  const ViewerScreen({Key? key}) : super(key: key);

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  GroupsController _groupController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: _mobileView(),
        desktop: _desktopView(),
      ),
      bottomNavigationBar: Responsive.isMobile(context)
          ? SizedBox()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: GestureDetector(
                    onLongPress: () => Get.back(),
                    child: Image.asset(
                      "assets/images/logo.png",
                      scale: 7,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Container _desktopView() {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              children: [
                ShiftsCard(),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Obx(
                  () => PeopleCard(
                    peopleEntered: _groupController.totalEntered,
                    peopleTotal: _groupController.totalPeople,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: kDefaultPadding,
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                ClockCard(),
                SizedBox(
                  height: 16,
                ),
                DevicesCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _mobileView() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            ShiftsCard(),
            SizedBox(
              height: kDefaultPadding,
            ),
            Obx(
              () => PeopleCard(
                peopleEntered: _groupController.totalEntered,
                peopleTotal: _groupController.totalPeople,
              ),
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            SizedBox(
              height: 16,
            ),
            DevicesCard(),
          ],
        ),
      ),
    );
  }
}
