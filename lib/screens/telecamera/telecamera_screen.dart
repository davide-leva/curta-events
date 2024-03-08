import 'dart:convert';

import 'package:admin/controllers/Config.dart';
import 'package:admin/screens/telecamera/components/camera.dart';
import 'package:admin/screens/telecamera/components/camera_selector.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../components/header.dart';
import '../party/components/balance.dart';
import 'components/multicamera.dart';

class TelecameraScreen extends StatefulWidget {
  @override
  State<TelecameraScreen> createState() => _TelecameraScreenState();
}

class _TelecameraScreenState extends State<TelecameraScreen> {
  int _camera = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: jsonDecode(Config.get('cameras')).length == 0
              ? [
                  Header(screenTitle: "Telecamera"),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  border(
                    Text("Telecamere non abilitate",
                        style: Theme.of(context).textTheme.titleLarge),
                  )
                ]
              : [
                  Header(screenTitle: "Telecamera"),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  CameraSelector(
                    onChange: (camera) => setState(() {
                      _camera = camera;
                    }),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  _camera == 0
                      ? Multicamera(
                          nCameras: jsonDecode(Config.get('cameras')).length,
                        )
                      : Camera(cameraIndex: _camera - 1)
                ],
        ),
      ),
    );
  }
}
