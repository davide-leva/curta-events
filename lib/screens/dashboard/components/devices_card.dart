import 'package:admin/controllers/Config.dart';
import 'package:admin/controllers/DevicesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/Device.dart';

class DevicesCard extends StatefulWidget {
  @override
  State<DevicesCard> createState() => _DevicesCardState();
}

class _DevicesCardState extends State<DevicesCard> {
  DevicesController _devicesController = Get.put(DevicesController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            kDefaultPadding,
          ),
          color: Theme.of(context).canvasColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dispostivi",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Obx(() => Column(
                children: _devicesController.devices
                    .map(
                      (device) => _deviceController(
                          context, device, _devicesController),
                    )
                    .toList(),
              )),
        ],
      ),
    );
  }
}

Widget _deviceController(
    BuildContext context, Device device, DevicesController controller) {
  return GestureDetector(
    onTap: () async {
      if (Config.get('call') == "false") return;
      if (device.isCaller) {
        controller.removeCaller(device.id);
        device.answer();
      } else {
        device.call();
      }
    },
    child: Container(
      padding: EdgeInsets.all(kDefaultPadding),
      margin: EdgeInsets.only(
        top: kDefaultPadding,
      ),
      decoration: BoxDecoration(
        color: device.isCaller
            ? Colors.amber.shade800
            : device.isAnswerer
                ? Colors.green
                : Colors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(device.icon),
            SizedBox(
              width: kDefaultPadding,
            ),
            Spacer(),
            Container(
              constraints: BoxConstraints(minWidth: 120),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      device.place,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      device.id,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.white,
              width: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  device.operator,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  device.type,
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}
