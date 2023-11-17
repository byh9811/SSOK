import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BasicLoadingPage extends StatefulWidget {
  const BasicLoadingPage({super.key});

  @override
  State<BasicLoadingPage> createState() => _BasicLoadingPageState();
}

class _BasicLoadingPageState extends State<BasicLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black.withOpacity(0.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.fallingDot(
              color: Colors.grey,
              size: 50,
            ),
          ),
        ],
      ),
    );
    ;
  }
}
