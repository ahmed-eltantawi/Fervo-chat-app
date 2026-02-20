import 'package:vibration/vibration.dart';

void vibration() async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate();
  }
}
