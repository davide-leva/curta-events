import 'package:admin/responsive.dart';
import 'package:admin/screens/components/button.dart';
import 'package:admin/screens/components/table_button.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

showPopUp(
  BuildContext context,
  String title,
  List<Widget> actions,
  Function() onSuccess, {
  String successTitle = "Inserisci",
  String cancelTitle = "Annulla",
  Color successColor = Colors.green,
  Color cancelColor = Colors.red,
  IconData successIcon = Icons.check,
  IconData cancelIcon = Icons.close,
}) {
  int n_widget = actions.length;
  actions = actions.fold(List<Widget>.empty(growable: true),
      (previousValue, element) {
    previousValue.add(element);
    previousValue.add(
      SizedBox(
        height: defaultPadding,
      ),
    );
    return previousValue;
  });

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Container(
              height: 230 + n_widget * 65,
              width: 300,
              color: Theme.of(context).canvasColor,
              child: Column(children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: defaultPadding * 2,
                ),
                ...actions,
                Spacer(),
                Responsive(
                  mobile: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TableButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onSuccess();
                          },
                          icon: successIcon,
                          color: successColor),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      TableButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: cancelIcon,
                        color: cancelColor,
                      ),
                    ],
                  ),
                  desktop: Row(
                    children: [
                      ActionButton(
                          title: successTitle,
                          onPressed: () {
                            Navigator.of(context).pop();
                            onSuccess();
                          },
                          icon: successIcon,
                          color: successColor),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      ActionButton(
                        title: cancelTitle,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: cancelIcon,
                        color: cancelColor,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      });
}
