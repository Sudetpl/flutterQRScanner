import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qrreader/utils/extract_info.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_qrreader/widgets/card.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class QrCodeViewer extends StatefulWidget {
  final Data data;

  const QrCodeViewer({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QrCodeViewerState();
}

class QrCodeViewerState extends State<QrCodeViewer> {
  final ScreenshotController screenshotController = ScreenshotController();
  void share() async {
    screenshotController.capture(delay: Duration()).then((image) async {
      String path = (await getExternalCacheDirectories())[0].path;
      File('$path/image.png').writeAsBytes(image);
      Share.shareFiles(['$path/image.png']);
    });
  }

  void save() async {
    Permission permission = Permission.storage;
    if (await permission.isGranted || await permission.request().isGranted) {
      screenshotController.capture(delay: Duration()).then((image) async {
        await ImageGallerySaver.saveImage(image, name: widget.data.type);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Image saved successfully")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Qr Code Generated"),
        actions: [
          IconButton(icon: Icon(Icons.arrow_downward), onPressed: save),
          IconButton(icon: Icon(Icons.share), onPressed: share),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(child: Icon(widget.data.icon)),
                  SizedBox(width: 10),
                  Text(widget.data.type),
                ],
              ),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  color: Colors.white,
                  child: QrImage(data: widget.data.construct),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
