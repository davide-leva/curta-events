import 'package:admin/screens/admin/components/icon_selector.dart';
import 'package:admin/screens/components/pop_up.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/DevicesController.dart';
import '../../../models/Device.dart';

class DevicesCard extends StatefulWidget {
  @override
  State<DevicesCard> createState() => _DevicesCardState();
}

class _DevicesCardState extends State<DevicesCard> {
  final DevicesController _controller = Get.put(DevicesController());

  TextEditingController _operatorController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  late String _type;
  late IconData _icon;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(defaultPadding),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Dispositivi",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              ...List.generate(
                _controller.devices.length,
                (index) => Row(
                  children: [
                    _deviceController(
                        context, _controller.devices[index], _controller, () {
                      _operatorController.text =
                          _controller.devices[index].operator;
                      _placeController.text = _controller.devices[index].place;
                      _type = _controller.devices[index].type;
                      _icon = _controller.devices[index].icon;

                      showPopUp(
                        context,
                        "Modifica dispositivo",
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
                            padding: EdgeInsets.only(left: defaultPadding),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownMenu<String>(
                              width: 240,
                              hintText: "Tipo",
                              initialSelection: _type,
                              menuHeight: 300,
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                                fillColor: Theme.of(context).cardColor,
                              ),
                              dropdownMenuEntries: ["Pr", "Member", "Admin"]
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
                            initialSelection: _icon,
                            onChange: (icon) => _icon = icon,
                          ),
                        ],
                        () => _controller.modify(
                          _controller.devices[index],
                          new Device(
                            id: _controller.devices[index].id,
                            operator: _operatorController.text,
                            place: _placeController.text,
                            type: _type,
                            icon: _icon,
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _deviceController(BuildContext context, Device device,
      DevicesController controller, void Function() onModify) {
    return Expanded(
      child: GestureDetector(
        onTap: onModify,
        child: Container(
          height: 80,
          padding: EdgeInsets.all(defaultPadding),
          margin: EdgeInsets.only(
            top: defaultPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Icon(device.icon),
                SizedBox(
                  width: defaultPadding,
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
                Text(
                  device.operator,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
