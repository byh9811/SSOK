import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppBody {
  final String title;
  final Widget widget;
  AppBody(
    this.title,
    this.widget,
  );
}

class TransferLoadingPage extends StatefulWidget {
  const TransferLoadingPage({super.key});

  @override
  State<TransferLoadingPage> createState() => _TransferLoadingPageState();
}

class _TransferLoadingPageState extends State<TransferLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: const Color(0xFF00ADEF),
              rightDotColor: const Color(0xFF21A038),
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
