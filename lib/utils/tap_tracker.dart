int onTaps = 0;
int maxOnTaps = 5;

Future<T> registerTap<T>(T Function() onTap) {
  if (onTaps++ == maxOnTaps) {
  } else
    onTap();
  return Future.value();
}
