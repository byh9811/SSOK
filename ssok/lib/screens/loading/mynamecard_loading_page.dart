import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MynamecardLoadingPage extends StatefulWidget {
  const MynamecardLoadingPage({super.key});

  @override
  State<MynamecardLoadingPage> createState() => _MynamecardLoadingPageState();
}

class _MynamecardLoadingPageState extends State<MynamecardLoadingPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SkeletonLoader(0.65),
              SizedBox(height: screenHeight * 0.02),
              SkeletonLoader(0.22),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.05),
                    child: SkeletonLoader(0.12),
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget SkeletonLoader(double size) {
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
}
