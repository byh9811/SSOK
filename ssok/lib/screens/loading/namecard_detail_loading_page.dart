import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NamecardDetailLoadingPage extends StatefulWidget {
  const NamecardDetailLoadingPage({super.key});

  @override
  State<NamecardDetailLoadingPage> createState() =>
      _NamecardDetailLoadingPageState();
}

class _NamecardDetailLoadingPageState extends State<NamecardDetailLoadingPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              children: [
                skeletonLoader(0.8),
                Align(
                  alignment: Alignment.topRight,
                  child: customSkeletonLoader(0.2, 0.07),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      customSkeletonLoader(0.3, 0.1),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: customSkeletonLoader(0.2, 0.07),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
                customSkeletonLoader(0.8, 0.02),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget skeletonLoader(double size) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Color.fromRGBO(240, 240, 240, 1),
      highlightColor: Colors.white10,
      child: Container(
        width: screenWidth * size,
        height: screenWidth * size * (5 / 9),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey),
      ),
    );
  }

  Widget customSkeletonLoader(double width, double height) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Color.fromRGBO(240, 240, 240, 1),
      highlightColor: Colors.white10,
      child: Container(
        width: screenWidth * width,
        height: screenWidth * height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey),
      ),
    );
  }
}
