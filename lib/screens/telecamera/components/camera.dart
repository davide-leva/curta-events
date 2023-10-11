import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../controllers/Config.dart';
import '../../components/button.dart';

final ValueNotifier<double> _zoom = ValueNotifier(0.0);
final ValueNotifier<bool> _torch = ValueNotifier(false);

class Camera extends StatelessWidget {
  Camera({
    required this.cameraIndex,
  });

  final int cameraIndex;

  @override
  Widget build(BuildContext context) {
    final String _endpoint =
        "http://${jsonDecode(Config.get('cameras'))[cameraIndex]['ip']}:8080";

    _zoom.addListener(() => _setZoom(_zoom.value.toInt(), _endpoint));

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(defaultPadding),
            ),
            child: Center(
              child: Mjpeg(
                stream: '$_endpoint/video',
                isLive: true,
                error: (_, __, ___) => Text(
                  "Telecamera non raggiungibile",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                loading: (_) => CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(defaultPadding),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ActionButton(
                title: "Torcia",
                onPressed: () => _toggleTorch(_endpoint),
                icon: Icons.flashlight_on,
                color: Colors.amber.shade800,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              ActionButton(
                title: "Foto",
                onPressed: () => _photo(_endpoint),
                icon: Icons.photo,
                color: Colors.lightBlue,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              ValueListenableBuilder<double>(
                valueListenable: _zoom,
                builder: (context, value, _) => SizedBox(
                  width: 300,
                  child: Slider(
                    label: "Zoom",
                    value: value,
                    min: 0,
                    max: 20,
                    autofocus: true,
                    onChanged: (value) {
                      _zoom.value = (value * 20).round().toDouble() / 20;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

_setZoom(int zoom, String endpoint) {
  http.get(Uri.parse('$endpoint/ptz?zoom=$zoom'));
}

_toggleTorch(String endpoint) {
  if (_torch.value) {
    http.get(Uri.parse('$endpoint/disabletorch'));
    _torch.value = false;
  } else {
    http.get(Uri.parse('$endpoint/enabletorch'));
    _torch.value = true;
  }
}

_photo(String endpoint) {
  http.get(Uri.parse('$endpoint/photoaf_save_only.jpg'));
}
