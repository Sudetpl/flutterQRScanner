import 'package:hive/hive.dart';

final String historyBox = 'history';
final String settingsBox = 'settings';

@HiveType(typeId: 0)
class QrCodeHolder {
  @HiveField(0)
  String data;

  @HiveField(1)
  String dateTime;

  @HiveField(2)
  bool isFavorited;

  QrCodeHolder({
    this.data,
    this.dateTime,
    this.isFavorited: false,
  });
}

class QrCodeHolderAdapter extends TypeAdapter<QrCodeHolder> {
  @override
  int get typeId => 0;

  @override
  QrCodeHolder read(BinaryReader reader) {
    return QrCodeHolder(
      data: reader.read(),
      dateTime: reader.read(),
      isFavorited: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, QrCodeHolder obj) {
    writer..write(obj.data)..write(obj.dateTime)..write(obj.isFavorited);
  }
}
