import 'package:admin/constants.dart';
import 'package:admin/controllers/Config.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/components/badge.dart';
import 'package:admin/screens/components/text_input.dart';
import 'package:admin/services/socket_service.dart';
import 'package:flutter/material.dart';

class ConnectionFailedScreen extends StatelessWidget {
  ConnectionFailedScreen({Key? key}) : super(key: key);

  final TextEditingController _dataServerController = TextEditingController(
    text: Config.get('dataEndpoint'),
  );
  final TextEditingController _socketServerController = TextEditingController(
    text: Config.get('socketEndpoint'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              scale: 5,
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            InfoBadge(
              color: Colors.red,
              text: "Connessione Fallita",
              size: 200,
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Container(
              width: Responsive.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : 400,
              padding: EdgeInsets.all(kDefaultPadding),
              margin: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(kDefaultPadding),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Connettività",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  TextInput(
                    textController: _dataServerController,
                    label: 'Data Server',
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  TextInput(
                    textController: _socketServerController,
                    label: 'Socket Server',
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ActionButton(
                        title: "Salva",
                        onPressed: () {
                          Config.set(
                              'dataEndpoint', _dataServerController.text);
                          Config.set(
                              'socketEndpoint', _socketServerController.text);
                          SocketService.init();
                        },
                        icon: Icons.save,
                        color: Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
