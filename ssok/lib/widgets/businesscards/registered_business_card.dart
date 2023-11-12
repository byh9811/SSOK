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
    final response = await apiService.getRequest(
        'namecard-service/', TokenManager().accessToken);
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
    businessCardData = BusinessCardData(
        favorites: [], memberSeq: 0, myExchangeItems: [], myNamecardItems: []);
    bringBusinessCardList();
  }

  @override
  Widget build(BuildContext context) {
    print(businessCardData.myExchangeItems.length);

    return Column(
      children: [
        MyBusinessCard(myNamecardItems: businessCardData.myNamecardItems),
        MyFavoriteCard(favorites: businessCardData.favorites),
        ExchangeCardList(myExchangeItems: businessCardData.myExchangeItems),
      ],
    );
  }
}

class MyFavoriteCard extends StatefulWidget {
  final List<NameCard> favorites;
  const MyFavoriteCard({super.key, required this.favorites});

  @override
  State<MyFavoriteCard> createState() => _MyFavoriteCard();
}

class _MyFavoriteCard extends State<MyFavoriteCard> {
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
                "즐겨찾기(${widget.favorites.length})",
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
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Divider(
            height: 1,
            color: Colors.black,
            thickness: 1,
          ),
          SizedBox(
            height:
                100, //////////////////////////////////////////////////////내부 높이랑 동일하게 설정하기
            child: ListView.builder(
              itemCount: widget.favorites.length,
              itemBuilder: (context, index) {
                NameCard data = widget.favorites[index];
                String namecardName = data.name;
                String namecardJob = data.job;
                String namecardImage = data.namecardImg;
                String namecardCompany = data.company;
                String namecardDateTime = data.exchangeDate;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/businesscard/detail',
                          arguments: data.exchangeSeq);
                    },
                    child: CustomListItem(
                      name: namecardName,
                      image: namecardImage,
                      job: namecardJob,
                      company: namecardCompany,
                      dateTime: namecardDateTime,
                      favorite: true,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class MyBusinessCard extends StatefulWidget {
  const MyBusinessCard({
    Key? key,
    required this.myNamecardItems,
  }) : super(key: key);
  final List<MyNameCard> myNamecardItems;

  @override
  _MyBusinessCardState createState() => _MyBusinessCardState();
}

class _MyBusinessCardState extends State<MyBusinessCard> {
  final CarouselController _carouselController = CarouselController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                          child: BusinessTransferModal(
                              myNamecardItem:
                                  widget.myNamecardItems[_currentPage]),
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
                Navigator.of(context).pushNamed("/businesscard/my",
                    arguments:
                        widget.myNamecardItems[_currentPage].namecardSeq);
              },
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: screenHeight * 0.18,
                  aspectRatio: 9 / 5,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    // 페이지가 변경될 때 호출되는 콜백
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                items: widget.myNamecardItems.map((item) {
                  return Image.network(item.namecardImg, fit: BoxFit.cover);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangeCardList extends StatefulWidget {
  final List<NameCard> myExchangeItems;
  const ExchangeCardList({
    Key? key,
    required this.myExchangeItems,
  }) : super(key: key);
  @override
  State<ExchangeCardList> createState() => _ExchangeCardListState();
}

class _ExchangeCardListState extends State<ExchangeCardList> {
  @override
  Widget build(BuildContext context) {
    print("뭐 : ${widget.myExchangeItems.length}");

    return Column(
      children: [
        ExchangeCardListHeader(namecardCnt: widget.myExchangeItems.length),
        ExchangeCardListBody(myExchangeItems: widget.myExchangeItems),
      ],
    );
  }
}

class ExchangeCardListHeader extends StatefulWidget {
  const ExchangeCardListHeader({Key? key, required this.namecardCnt})
      : super(key: key);
  final int namecardCnt;
  @override
  State<ExchangeCardListHeader> createState() => _ExchangeCardListHeaderState();
}

class _ExchangeCardListHeaderState extends State<ExchangeCardListHeader> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(widget.namecardCnt);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                "전체(${widget.namecardCnt})",
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

class ExchangeCardListBody extends StatefulWidget {
  const ExchangeCardListBody({
    Key? key,
    required this.myExchangeItems,
  }) : super(key: key);
  final List<NameCard> myExchangeItems;
  @override
  State<ExchangeCardListBody> createState() => _ExchangeCardListBodyState();
}

//
class _ExchangeCardListBodyState extends State<ExchangeCardListBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("========");
    print(widget.myExchangeItems.length);

    return SizedBox(
      height: screenHeight * 0.57 - 60.0,
      child: ListView.builder(
        itemCount: widget.myExchangeItems.length,
        itemBuilder: (context, index) {
          NameCard data = widget.myExchangeItems[index];
          String namecardName = data.name;
          String namecardJob = data.job;
          String namecardImage = data.namecardImg;
          String namecardCompany = data.company;
          String namecardDateTime = data.exchangeDate;
          bool favorite = data.isFavorite;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.04,
              vertical: screenWidth * 0.01,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/businesscard/detail',
                    arguments: data.exchangeSeq);
              },
              child: CustomListItem(
                name: namecardName,
                image: namecardImage,
                job: namecardJob,
                company: namecardCompany,
                dateTime: namecardDateTime,
                favorite: favorite,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.name,
    required this.image,
    required this.job,
    required this.company,
    required this.dateTime,
    required this.favorite,
  }) : super(key: key);

  final String name;
  final String image;
  final String job;
  final String company;
  final String dateTime;
  final bool favorite;

  // ApiService apiService = ApiService();

  // void makeFavorite()async{
  //   final response = await apiService.postRequest("namecard-service/like",{},TokenManager().accessToken);
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // makeFavorite();
                      },
                      child: favorite
                          ? Icon(Icons.star, color: Colors.yellow)
                          : Icon(Icons.star_border_outlined,
                              color: Colors.yellow),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.01, bottom: screenHeight * 0.005),
                  child: Text(
                    job,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF858585),
                    ),
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF858585),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 9 / 5,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Image.network(image, fit: BoxFit.cover),
              ),
            ),
          )
        ],
      ),
    );
  }
}