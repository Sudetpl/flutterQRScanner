import 'package:flutter/material.dart';

class Data {
  final String data;
  final String type = "Text";
  final IconData icon = Icons.description;
  Data(this.data);

  String get construct {
    return data;
  }

  String get getFormatedData {
    return data;
  }
}

class SmsData extends Data {
  final String type = "Message";
  final IconData icon = Icons.sms;

  final String number;
  final String message;
  SmsData({this.number, this.message}) : super('');

  factory SmsData.parse(String data) {
    List<String> tokens = data.split(':');
    final String number = tokens[1];
    final String message = tokens[2];
    return SmsData(number: number, message: message);
  }

  String get construct {
    return 'smsto:$number:$message';
  }

  String get getFormatedData {
    return 'to: $number\nmessage: $message';
  }
}

class MailData extends Data {
  final String type = "Mail";
  final IconData icon = Icons.mail;

  final String to;
  final String subject;
  final String body;

  MailData({this.to, this.subject, this.body}) : super('');

  factory MailData.parse(String data) {
    List<String> token = data.split(';');
    final String to = token[0].substring(10);
    final String subject = token[1].substring(4);
    final String body = token[2].substring(5);
    return MailData(to: to, subject: subject, body: body);
  }

  String get construct {
    return 'MATMSG:TO:$to;SUB:$subject;BODY:$body';
  }

  String get getFormatedData {
    return 'to: $to\nsubject: $subject\nbody: $body';
  }
}

class ContactData extends Data {
  final String type = "Contact";
  final IconData icon = Icons.contact_page;

  final String firstname;
  final String lastname;
  final String number;
  final String email;
  final String address;

  ContactData(
      {this.firstname, this.lastname, this.number, this.email, this.address})
      : super('');

  factory ContactData.parse(String data) {
    List<String> tokens = data.split(';');
    List<String> fullname = tokens[0].substring(9).split(',');
    final String firstname = fullname[0];
    final String lastname = fullname[1];
    final String number = tokens[1].substring(4);
    final String email = tokens[2].substring(6);
    final String address = tokens[3].substring(4);
    return ContactData(
      firstname: firstname,
      lastname: lastname,
      number: number,
      email: email,
      address: address,
    );
  }

  String get construct {
    return "MECARD:N:$firstname,$lastname;TEL:$number;EMAIL:$email;ADR:$address;";
  }

  String get getFormatedData {
    return 'firstname: $firstname\lastname: $lastname\number: $number\nemail: $email\naddress: $address';
  }
}

class TeleData extends Data {
  final String type = "Telephone";
  final IconData icon = Icons.call;

  final String number;
  TeleData({this.number}) : super('');

  factory TeleData.parse(String data) {
    final number = data.substring(4);
    return TeleData(number: number);
  }

  String get construct {
    return 'tel:$number';
  }

  String get getFormatedData {
    return 'tele: $number';
  }
}

class UrlData extends Data {
  final String type = "Link";
  final IconData icon = Icons.language;

  UrlData(String data) : super(data);
}

Data extractInfo(String data) {
  final urlPattern =
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
  try {
    if (data.contains('smsto:')) return SmsData.parse(data);
    if (data.contains('MATMSG:')) return MailData.parse(data);
    if (data.contains('MECARD:')) return ContactData.parse(data);
    if (data.contains('tel:')) return TeleData.parse(data);
    if (RegExp(urlPattern, caseSensitive: false).hasMatch(data))
      return UrlData(data);
  } catch (e) {}
  return Data(data);
}
