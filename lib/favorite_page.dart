import 'package:flutter/material.dart';
import 'package:flutter_qrreader/qrcode_result.dart';
import 'package:flutter_qrreader/utils/boxes.dart';
import 'package:flutter_qrreader/utils/extract_info.dart';
import 'package:flutter_qrreader/utils/load_page.dart';
import 'package:flutter_qrreader/utils/tap_tracker.dart';
import 'package:flutter_qrreader/widgets/card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
class Favourite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<QrCodeHolder>(historyBox).listenable(),
          builder: (_, Box<QrCodeHolder> box, __) {
            final data = box
                .toMap()
                .values
                .where((qrCodeHolder) => qrCodeHolder.isFavorited)
                .toList();
            return data.isEmpty
                ? Container()
                : CardList(
                    items: data
                        .asMap()
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
                                  icon: Icon(qrCodeHolder.isFavorited
                                      ? Icons.star
                                      : Icons.star_outline),
                                  onPressed: () => box.put(
                                    key,
                                    qrCodeHolder
                                      ..isFavorited = !qrCodeHolder.isFavorited,
                                  ),
                                ),
                              ],
                              onTap: () => registerTap(() => loadPage(
                                    context,
                                    QrCodeResult(
                                      scanInfo: Barcode(
                                        qrCodeHolder.data,
                                        BarcodeFormat.qrcode,
                                        [],
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        })
                        .values
                        .toList()
                        .reversed
                        .toList(),
                  );
          },
        ),
      ),
    );
  }
}
