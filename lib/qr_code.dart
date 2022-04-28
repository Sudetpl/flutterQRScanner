import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrreader/qrcode_result.dart';
import 'package:flutter_qrreader/qrcode_scanner_page.dart';
import 'package:flutter_qrreader/utils/boxes.dart';
import 'package:flutter_qrreader/utils/load_page.dart';
import 'package:flutter_qrreader/widgets/card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';

class QrCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrCode();
}

class _QrCode extends State<QrCode> {
  String get settingsBox => null;

  Future<void> showResult(BuildContext context, Barcode scanInfo) async {
    Hive.box<QrCodeHolder>(historyBox).add(
      QrCodeHolder(
        data: scanInfo.code,
        dateTime: DateFormat('kk:mm dd-MM-yyyy').format(DateTime.now()),
      ),
    );
    if (Hive.box(settingsBox).get('vibration', defaultValue: true))
      Vibration.vibrate(duration: 200);
    if (Hive.box(settingsBox).get('sound', defaultValue: true))
      AudioCache().play("nice_notification.mp3");
    await loadPage(context, QrCodeResult(scanInfo: scanInfo));
  }

  void extractQrCodeDataFromImage(BuildContext context) {
    ImagePicker().getImage(source: ImageSource.gallery).then((file) async {
      QrCodeToolsPlugin.decodeFrom(file.path)
          .then((data) =>
              showResult(context, Barcode(data, BarcodeFormat.qrcode, [])))
          .catchError((e) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Qr code invalid"))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("assets/cover.jpg"),
          CardList(
            items: [
              CardListItem(
                onTap: () => loadPage(context, QrCodeScanner()),
                icon: Icon(FontAwesomeIcons.camera),
                text: "Camera Scan",
              ),
            ],
          ),
        ],
      ),
    );
  }

  getList() {}
}
