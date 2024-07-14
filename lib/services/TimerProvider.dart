import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider extends ChangeNotifier {
  late Timer _timer;
  int _remainingTime = 7; // Initial time in seconds

  int get remainingTime => _remainingTime;

  void startTimer(void Function() onTimerComplete) {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners(); // Notify listeners to update UI
      } else {
        timer.cancel();
        onTimerComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
