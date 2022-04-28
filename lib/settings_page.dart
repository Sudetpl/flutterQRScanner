import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrreader/utils/boxes.dart';
import 'package:flutter_qrreader/widgets/card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool showBanner = false;

  get bannerId => null;

  get testBannerId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: Hive.box(settingsBox).listenable(),
                builder: (context, Box box, widget) {
                  return CardList(
                    items: [
                      CardListItem(
                        icon: Icon(Icons.volume_up),
                        text: "Sound",
                        suffixIcon: Switch(
                          value: box.get('sound', defaultValue: true),
                          onChanged: (value) => box.put('sound', value),
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
