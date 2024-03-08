import 'package:flutter/material.dart';

import '../../../constants.dart';

class Allert extends StatefulWidget {
  @override
  State<Allert> createState() => _AllertState();
}

class _AllertState extends State<Allert> {
  bool _closed = false;

  @override
  Widget build(BuildContext context) {
    return _closed
        ? Container()
        : Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(
                    bottom: kDefaultPadding,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.yellow.withOpacity(0.4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dangerous_rounded,
                        size: 30,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      Text(
                        "Questa è una versione di test!",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => setState(() {
                          _closed = true;
                        }),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
