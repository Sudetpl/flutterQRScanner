import 'package:flutter/material.dart';
import 'package:flutter_qrreader/utils/boxes.dart';
import 'package:flutter_qrreader/favorite_page.dart';
import 'package:flutter_qrreader/history_page.dart';
import 'package:flutter_qrreader/qr_code.dart';
import 'package:flutter_qrreader/qrcode_scanner_page.dart';
import 'package:flutter_qrreader/settings_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_qrreader/utils/tap_tracker.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<QrCodeHolder>(QrCodeHolderAdapter());
  await Hive.openBox<QrCodeHolder>(historyBox);
  await Hive.openBox(settingsBox);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qr code scanner barcode Pro',
      theme: ThemeData(
        primaryColor: Colors.purple,
        primaryColorDark: Colors.purple,
        accentColor: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  int index = 0;
  bool loading = true;
  bool showBanner = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() => registerTap(() => setState(() {})));
    (() async {
    })();
  }

  Widget buildBody() {
    final children = [
      QrCode(),
      History(),
      Favourite(),
      Settings(),
      QrCodeGenerator(),
      QrCodeScanner(),
    ];
    return children[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.purple,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Qr Code Scanner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.purple,
            height: 50,
            child: TabBar(
              controller: controller,
              tabs: [
                Text("Scanner"),
                Text("History"),
                Text("Settings"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                QrCode(),
                History(),
                Settings(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        ],
      ),
    );
  }
}

class QrCodeGenerator {}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}