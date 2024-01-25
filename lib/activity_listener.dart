import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityTimeoutListener extends StatefulWidget {
  Widget child;
  Duration duration;
  VoidCallback onTimeout;

  ActivityTimeoutListener({
    Key? key,
    required this.child,
    required this.duration,
    required this.onTimeout,
  }) : super(key: key);

  @override
  State<ActivityTimeoutListener> createState() =>
      _ActivityTimeoutListenerState();
}

class _ActivityTimeoutListenerState extends State<ActivityTimeoutListener> {
  Timer? _timer;

  _startTimer() {
    print("Timer Reset !!!");
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(widget.duration, () {
      print("Timeout!!!");
      widget.onTimeout();
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      // _accessToken = pref.getString('accessToken') ?? "";
      if ((pref.getString('accessToken') ?? "").isNotEmpty) {
        debugPrint("ACCESS TOKEN PRESENT ...");
        _startTimer();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _startTimer();
      },
      child: widget.child,
    );
  }
}
