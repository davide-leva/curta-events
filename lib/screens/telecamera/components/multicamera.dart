import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

import '../../../constants.dart';
import '../../../controllers/Config.dart';

class Multicamera extends StatelessWidget {
  Multicamera({
    required this.nCameras,
  });

  final int nCameras;

  @override
  Widget build(BuildContext context) {
    String _endpoint(int i) =>
        "http://${jsonDecode(Config.get('cameras'))[i]['ip']}:8080";

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(kDefaultPadding),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              nCameras,
              (i) => Mjpeg(
                width: MediaQuery.sizeOf(context).width * 0.4,
                stream: '${_endpoint(i)}/video',
                isLive: true,
                error: (_, __, ___) => Center(
                  child: Text(
                    "Telecamera non raggiungibile",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                loading: (_) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
