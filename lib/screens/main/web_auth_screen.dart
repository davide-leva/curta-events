import 'package:admin/screens/components/text_input.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/socket_service.dart';

class WebAuthScreen extends StatefulWidget {
  WebAuthScreen({Key? key}) : super(key: key);

  @override
  State<WebAuthScreen> createState() => _WebAuthScreenState();
}

class _WebAuthScreenState extends State<WebAuthScreen> {
  bool _authFailed = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _userController = TextEditingController();
    TextEditingController _pwdController = TextEditingController();

    SocketService.setListener(
      EventType.AUTH_FAIL,
      (_) => setState(
        () {
          _authFailed = true;
        },
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              scale: 5,
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              width: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(kDefaultPadding),
              ),
              child: Column(
                children: [
                  TextInput(
                    textController: _userController,
                    label: "Utente",
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  TextInput(
                    textController: _pwdController,
                    obscure: true,
                    label: "Password",
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  _authFailed
                      ? Text(
                          "Credenziali errate",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.red),
                        )
                      : Container(),
                  _authFailed
                      ? SizedBox(
                          height: kDefaultPadding,
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () => SocketService.login(
                        _userController.text, _pwdController.text),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.all(kDefaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                      ),
                      child: Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
