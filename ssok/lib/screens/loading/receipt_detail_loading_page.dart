import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReceiptDetailLoadingPage extends StatefulWidget {
  const ReceiptDetailLoadingPage({super.key});

  @override
  State<ReceiptDetailLoadingPage> createState() =>
      _ReceiptDetailLoadingPageState();
}

class _ReceiptDetailLoadingPageState extends State<ReceiptDetailLoadingPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.03),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                customSkeletonLoader(0.5, 0.08),
                customSkeletonLoader(0.25, 0.1),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Align(
            alignment: Alignment.centerRight,
            child: customSkeletonLoader(0.43, 0.09),
          ),
          SizedBox(height: screenHeight * 0.01),
          customSkeletonLoader(1, 0.02),
          SizedBox(height: screenHeight * 0.008),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.45, 0.09),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.28, 0.09),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.2, 0.09),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.2, 0.09),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          customSkeletonLoader(1, 0.02),
          SizedBox(height: screenHeight * 0.008),
          customSkeletonLoader(1, 0.09),
          SizedBox(height: screenHeight * 0.008),
          customSkeletonLoader(1, 0.09),
          SizedBox(height: screenHeight * 0.008),
          customSkeletonLoader(1, 0.02),
          SizedBox(height: screenHeight * 0.008),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.2, 0.09),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.2, 0.09),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          customSkeletonLoader(1, 0.02),
          SizedBox(height: screenHeight * 0.011),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customSkeletonLoader(0.2, 0.09),
              customSkeletonLoader(0.5, 0.09),
            ],
          ),
        ],
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
