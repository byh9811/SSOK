import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/dto/business_card_data.dart';
import 'package:ssok/widgets/modals/business_transfer_modal.dart';
import 'package:ssok/http/http.dart';

class RegisteredBusinessCard extends StatefulWidget {
  const RegisteredBusinessCard({super.key});

  @override
  State<RegisteredBusinessCard> createState() => _RegisteredBusinessCardState();
}

class _RegisteredBusinessCardState extends State<RegisteredBusinessCard> {
  ApiService apiService = ApiService();
  late BusinessCardData businessCardData;

  void bringBusinessCardList() async {
    final response = await apiService.getRequest('namecard-service/', TokenManager().accessToken);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      print("registered_business_card // bringBusinessCardList");
      print(jsonData["response"]);
      setState(() {
        businessCardData = BusinessCardData.fromJson(jsonData['response']);
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    businessCardData = BusinessCardData(favorites: [],memberSeq: 0,myExchangeItems: [],myNamecardItems: []);
    bringBusinessCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyBusinessCard(myNamecardItems : businessCardData.myNamecardItems),
        // BusinessCardList(myExchangeItems: businessCardData.myExchangeItems),
      ],
    );
  }
}

class MyBusinessCard extends StatelessWidget {
  const MyBusinessCard({
    Key? key,
    required this.myNamecardItems,
  }) : super(key: key);
  final List<MyNameCard> myNamecardItems;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
     final CarouselController _carouselController = CarouselController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "내 명함",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.06, screenHeight * 0.03),
                    backgroundColor: Color(0xFF3B8CED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: BusinessTransferModal(namecardSeq: myNamecardItems[0].namecardSeq),
                        );
                      },
                    );
                  },
                  child: Text(
                    "명함 교환",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("/businesscard/my");
              },
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: screenHeight * 0.18,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: myNamecardItems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return AspectRatio(
                        aspectRatio: 9 / 5,
                        child: Image.network(item.namecardImg, fit: BoxFit.cover),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BusinessCardList extends StatefulWidget {
  final List<MyNameCard> myExchangeItems;
  const BusinessCardList({
    Key? key,
    required this.myExchangeItems,
  }) : super(key: key);
  @override
  State<BusinessCardList> createState() => _BusinessCardListState(myExchangeItems);
}

class _BusinessCardListState extends State<BusinessCardList> {

  final List<MyNameCard> myExchangeItems;
  _BusinessCardListState(this.myExchangeItems);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        BusinessCardListHeader(namecardCnt: myExchangeItems.length),
        // BusinessCardListBody(myExchangeItems: myExchangeItems),
      ],
    );
  }
}


class BusinessCardListHeader extends StatefulWidget {
  final int namecardCnt;
  const BusinessCardListHeader({super.key, required this.namecardCnt});

  @override
  State<BusinessCardListHeader> createState() => _BusinessCardListHeaderState(namecardCnt);
}

class _BusinessCardListHeaderState extends State<BusinessCardListHeader> {
  final int namecardCnt;
  _BusinessCardListHeaderState(this.namecardCnt);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                "전체(${namecardCnt})",
                style: TextStyle(fontSize: 18),
              )),
              InkWell(
                onTap: () {
                  print("등록일순");
                },
                child: Row(
                  children: [
                    Icon(Icons.tune),
                    Text("등록일 순"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/businesscard/map');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenHeight * 0.007,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.map,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              "지도로 보기",
                              style: TextStyle(fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Divider(
            height: 1,
            color: Colors.black,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}


// class BusinessCardListBody extends StatefulWidget {
//   const BusinessCardListBody({
//     Key? key,
//     required this.myExchangeItems,
//   }) : super(key: key);
//   final List<MyNameCard> myExchangeItems;
//   @override
//   State<BusinessCardListBody> createState() => _BusinessCardListBodyState(myExchangeItems);
// }

// class _BusinessCardListBodyState extends State<BusinessCardListBody> {
//   final List<MyNameCard> businessCardList;
  
//   _BusinessCardListBodyState(this.businessCardList);
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return SizedBox(
//       height: screenHeight * 0.57 - 60.0,
//       child: ListView.builder(
//         itemCount: businessCardList.length,
//         itemBuilder: (context, index) {
//           MyNameCard data = businessCardList[index];
//           String namecardName = data.namecardName;
//           String namecardJob = data.namecardJob;
//           String namecardImage = data.namecardImage;
//           String namecardCompany = data.namecardCompany;
//           String namecardDateTime = data.date;

//           return Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenHeight * 0.04,
//               vertical: screenWidth * 0.01,
//             ),
//             child: InkWell(
//               onTap: () {
//                 Navigator.of(context).pushNamed('/businesscard/detail',arguments: data.exchangeSeq);
//               },
//               child: CustomListItem(
//                 name: namecardName,
//                 image: namecardImage,
//                 job: namecardJob,
//                 company: namecardCompany,
//                 dateTime: namecardDateTime,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// class CustomListItem extends StatelessWidget {
//   const CustomListItem({
//     Key? key,
//     required this.name,
//     required this.image,
//     required this.job,
//     required this.company,
//     required this.dateTime,
//   }) : super(key: key);

//   final String name;
//   final String image;
//   final String job;
//   final String company;
//   final String dateTime;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return SizedBox(
//       width: screenWidth,
//       height: screenHeight * 0.1,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: screenWidth * 0.01),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       top: screenHeight * 0.01, bottom: screenHeight * 0.005),
//                   child: Text(
//                     job,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF858585),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   company,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF858585),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AspectRatio(
//               aspectRatio: 9 / 5,
//               child: Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey,
//                       offset: Offset(0, 2),
//                       blurRadius: 1.0,
//                     ),
//                   ],
//                 ),
//                 child: Image.network(image, fit: BoxFit.cover),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
