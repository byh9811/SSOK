import 'dart:async';

import 'package:flutter/material.dart';

class CreditCardPaymentTimer extends StatefulWidget {
  const CreditCardPaymentTimer({super.key});

  @override
  State<CreditCardPaymentTimer> createState() => _CreditCardPaymentTimer();
}

class _CreditCardPaymentTimer extends State<CreditCardPaymentTimer> {
  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center,
    child: _Timer());
  }
}

class _Timer extends StatefulWidget {
  const _Timer({Key? key}) : super(key: key);

  @override
  State<_Timer> createState() => __TimerState();
}

class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x).take(ticks);
  }
}

class __TimerState extends State<_Timer> {
  late StreamSubscription<int> subscription;
  int? _currentTick;
  bool _isPaused = false;

  @override
  initState() {
    super.initState();
    _start(59);
  }

  void _start(int duration) {
    subscription = Ticker().tick(ticks: duration+1).listen((value) {
      setState(() {
        _isPaused = false;
        _currentTick = value; 
      });
    });
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
    subscription.resume();
  }

  void _pause() {
    setState(() {
      _isPaused = true;
    });
    subscription.pause();
  }

  @override
  Widget build(BuildContext context) {
    return
    Text(_currentTick == null ? '' : (_currentTick!-1).toString(),
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  
  }
}

