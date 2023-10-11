import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../controllers/Config.dart';
import '../../components/pop_up.dart';
import '../../components/text_input.dart';

class ColorPicker extends StatefulWidget {
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final TextEditingController _colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(
                left: defaultPadding, right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Colori",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: List.generate(
                    Config.get('colors').split(', ').length,
                    (index) => GestureDetector(
                      onTap: () => setState(
                        () {
                          List<String> colors =
                              Config.get('colors').split(', ');
                          colors.removeAt(index);
                          Config.set('colors', colors.join(', '));
                        },
                      ),
                      child: Container(
                        margin: EdgeInsets.only(right: 8, bottom: 4),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: HexColor.fromHex(
                              Config.get('colors').split(', ')[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: defaultPadding,
        ),
        GestureDetector(
          onTap: () {
            showPopUp(
              context,
              "Aggiungi colore",
              [
                TextInput(
                  textController: _colorController,
                  label: "HEX Colore",
                )
              ],
              () => setState(
                () {
                  List<String> colors = Config.get('colors').split(', ');
                  colors.add(_colorController.text);
                  Config.set('colors', colors.join(', '));
                },
              ),
            );
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.lightBlue),
                child: Icon(Icons.add),
              ),
            ],
          ),
        )
      ],
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.white;
    }
  }
}
