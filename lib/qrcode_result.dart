import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:flutter_qrreader/utils/extract_info.dart';
import 'package:flutter_qrreader/widgets/card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeResult extends StatefulWidget {
  final Barcode scanInfo;

  QrCodeResult({Key key, @required this.scanInfo});

  @override
  State<StatefulWidget> createState() => QrCodeResultState();
}

class QrCodeResultState extends State<QrCodeResult> {
  Data data;

  void copy() async {
    await Clipboard.setData(ClipboardData(text: data.getFormatedData));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Information copied successfully")));
  }

  void share() => Share.share(data.getFormatedData);

  Widget buildBody() {
    switch (data.runtimeType) {
      case SmsData:
        return SmsView(data: data);
      case MailData:
        return MailView(data: data);
      case ContactData:
        return ContactView(data: data);
      case TeleData:
        return TeleView(data: data);
      case UrlData:
        return UrlView(data: data);
      default:
        return View(data: data);
    }
  }

  @override
  void initState() {
    super.initState();
    data = extractInfo(widget.scanInfo.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.type),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.copy), onPressed: copy),
          IconButton(icon: Icon(Icons.share), onPressed: share),
        ],
      ),
      body: buildBody(),
    );
  }
}

class SmsView extends StatelessWidget {
  final SmsData data;

  const SmsView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(data.icon)),
              SizedBox(width: 10),
              Text(data.type),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              text: 'To: ${data.number}',
              suffixIcon: Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            child: TextField(
              controller: TextEditingController(text: data.message),
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Message",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MailView extends StatelessWidget {
  final MailData data;

  const MailView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(data.icon)),
              SizedBox(width: 10),
              Text(data.type),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              text: 'To: ${data.to}',
              suffixIcon: Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              text: 'Subject: ${data.subject}',
              suffixIcon: Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            child: TextField(
              controller: TextEditingController(text: data.body),
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Message",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactView extends StatelessWidget {
  final ContactData data;

  const ContactView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(data.icon)),
              SizedBox(width: 10),
              Text(data.type),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              icon: Icon(Icons.person),
              text: '${data.firstname} ${data.lastname}',
              suffixIcon: Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              icon: Icon(Icons.call),
              text: data.number,
              suffixIcon: Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              icon: Icon(Icons.email),
              text: data.email,
              suffixIcon: Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: CardListItem(
              icon: Icon(Icons.home),
              text: data.address,
              suffixIcon: Container(),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Permission permission = Permission.contacts;
              if (await permission.isGranted ||
                  await permission.request().isGranted) {
                Contacts.addContact(Contact(
                  givenName: data.firstname,
                  familyName: data.lastname,
                  phones: [Item(label: 'mobile', value: data.number)],
                  emails: [Item(label: 'email', value: data.email)],
                  postalAddresses: [PostalAddress(region: data.address)],
                )).then((_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Contact sdded successfully"))));
              }
            },
            icon: Icon(Icons.person_add),
            label: Text("Add"),
          ),
        ],
      ),
    );
  }
}

class TeleView extends StatelessWidget {
  final TeleData data;

  const TeleView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(data.icon)),
              SizedBox(width: 10),
              Text(data.type),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              data.number,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => launch(data.construct),
            icon: Icon(Icons.phone_forwarded_sharp),
            label: Text("call"),
          ),
        ],
      ),
    );
  }
}

class UrlView extends StatelessWidget {
  final UrlData data;

  const UrlView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(data.icon)),
              SizedBox(width: 10),
              Text(data.type),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              data.data,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => launch(data.data),
            icon: Icon(Icons.open_in_browser),
            label: Text("Open"),
          ),
        ],
      ),
    );
  }
}

class View extends StatelessWidget {
  final Data data;

  const View({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(data.icon)),
              SizedBox(width: 10),
              Text(data.type),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              data.data,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}