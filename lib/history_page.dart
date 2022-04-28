import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrreader/qrcode_result.dart';
import 'package:flutter_qrreader/utils/boxes.dart';
import 'package:flutter_qrreader/utils/extract_info.dart';
import 'package:flutter_qrreader/utils/load_page.dart';
import 'package:flutter_qrreader/utils/tap_tracker.dart';
import 'package:flutter_qrreader/widgets/card.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<History> {
  bool showBanner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<QrCodeHolder>(historyBox).listenable(),
          builder: (_, Box<QrCodeHolder> box, __) {
            return Column(children: [
              box.isEmpty
                  ? Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No Qr Code Scanned Yet"),
                        ),
                      ),
                    )
                  : CardList(
                      items: box
                          .toMap()
                          .map((key, qrCodeHolder) {
                            Data data = extractInfo(qrCodeHolder.data);
                            return MapEntry(
                              key,
                              ListItem(
                                  icon: Icon(data.icon),
                                  title: data.type,
                                  subTitle: qrCodeHolder.dateTime,
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => box.delete(key),
                                    )
                                  ],
                                  onTap: () => registerTap(
                                        () => loadPage(
                                          context,
                                          QrCodeResult(
                                            scanInfo: Barcode(
                                              qrCodeHolder.data,
                                              BarcodeFormat.qrcode,
                                              [],
                                            ),
                                          ),
                                        ),
                                      )),
                            );
                          })
                          .values
                          .toList()
                          .reversed
                          .toList(),
                    ),
            ]);
          },
        ),
      ),
    );
  }

  extractInfo(data) {}
}
