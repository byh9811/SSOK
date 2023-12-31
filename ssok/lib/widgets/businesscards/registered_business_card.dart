import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ssok/http/token_manager.dart';
import 'package:ssok/dto/business_card_data.dart';
import 'package:ssok/screens/loading/basic_loading_page.dart';
import 'package:ssok/widgets/modals/business_create_modal.dart';
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
        // Navigator.of(context).pop();
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

    return SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(
          height: 230,
          child:
              MyBusinessCard(myNamecardItems: businessCardData.myNamecardItems),
        ),
        SizedBox(
          height: 20,
        ),
        MyFavoriteCard(favorites: businessCardData.favorites),
        SizedBox(
          height: 30,
        ),
        ExchangeCardList(myExchangeItems: businessCardData.myExchangeItems),
      ]),
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
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "즐겨찾기(${widget.favorites.length})",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Divider(
            height: 1,
            color: Colors.black,
            thickness: 1,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.favorites.length,
            itemBuilder: (context, index) {
              NameCard data = widget.favorites[index];
              String namecardName = data.name;
              String namecardJob = data.job;
              String namecardImage = data.namecardImg;
              String namecardCompany = data.company;
              String namecardDateTime = data.exchangeDate;
              int exchangeSeq = data.exchangeSeq;
              String updateStatus = data.updateStatus;
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.01,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/businesscard/detail', arguments: {
                      'exchangeSeq': data.exchangeSeq,
                      'additionalData': data.updateStatus,
                    });
                  },
                  child: CustomListItem(
                    name: namecardName,
                    image: namecardImage,
                    job: namecardJob,
                    company: namecardCompany,
                    dateTime: namecardDateTime,
                    favorite: true,
                    exchangeSeq: exchangeSeq,
                    updateStatus: updateStatus,
                  ),
                ),
              );
            },
          ),
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
  int _currentPage = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        minimumSize:
                            Size(screenWidth * 0.06, screenHeight * 0.03),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: BusinessCreateModal(),
                        );
                      },
                    );
                  },
                  child: Text(
                    '새로운 명함 등록하기',
                    style: TextStyle(fontSize: 15, color: Color(0xFF00ADEF)),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: screenHeight * 0.18,
                      aspectRatio: 5 / 3,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    items: widget.myNamecardItems.map((item) {
                      return CachedNetworkImage(
                        imageUrl: item.namecardImg,
                        placeholder: (context, url) => SkeletonLoader(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error), //
                        fit: BoxFit.cover,
                      );
                      // return Image.network(
                      //   item.namecardImg,
                      //   fit: BoxFit.cover,
                      // );
                    }).toList(),
                  ),
                  // 왼쪽 화살표
                  Positioned(
                    left: 1,
                    child: _currentPage > 0
                        ? InkWell(
                            onTap: () => _carouselController.previousPage(),
                            child:
                                Icon(Icons.arrow_back_ios, color: Colors.black),
                          )
                        : SizedBox.shrink(),
                  ),
                  // 오른쪽 화살표
                  Positioned(
                    right: 1,
                    child: _currentPage < widget.myNamecardItems.length - 1
                        ? InkWell(
                            onTap: () => _carouselController.nextPage(),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SkeletonLoader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Color.fromRGBO(240, 240, 240, 1),
      highlightColor: Colors.white10,
      child: Container(
        width: screenWidth * 0.6,
        height: screenWidth * 0.6 * (5 / 9),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey),
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
  List<NameCard> sortedExchangeItems = [];
  bool sortByRegistrationDate = true;

  @override
  void initState() {
    super.initState();
    sortedExchangeItems = List.from(widget.myExchangeItems);
    sortedExchangeItems.sort((a, b) => a.name.compareTo(b.name));
  }

  void myEschangeItemsSort() {
    setState(() {
      sortByRegistrationDate = !sortByRegistrationDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("교환 명함 길이 : ${widget.myExchangeItems.length}");

    if (sortByRegistrationDate) {
      sortedExchangeItems = List.from(widget.myExchangeItems);
      sortedExchangeItems
          .sort((a, b) => a.exchangeDate.compareTo(b.exchangeDate));
    } else {
      sortedExchangeItems = List.from(widget.myExchangeItems);
      sortedExchangeItems.sort((a, b) => a.name.compareTo(b.name));
    }

    return Column(
      children: [
        ExchangeCardListHeader(
          namecardCnt: widget.myExchangeItems.length,
          onSortPressed: myEschangeItemsSort,
          sortByRegistrationDate: sortByRegistrationDate,
        ),
        ExchangeCardListBody(myExchangeItems: sortedExchangeItems),
      ],
    );
  }
}

class ExchangeCardListHeader extends StatefulWidget {
  const ExchangeCardListHeader({
    Key? key,
    required this.namecardCnt,
    required this.onSortPressed,
    required this.sortByRegistrationDate,
  }) : super(key: key);
  final int namecardCnt;
  final VoidCallback onSortPressed;
  final bool sortByRegistrationDate;
  @override
  State<ExchangeCardListHeader> createState() => _ExchangeCardListHeaderState();
}

class _ExchangeCardListHeaderState extends State<ExchangeCardListHeader> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("교환 명함 갯수 : " + widget.namecardCnt.toString());
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
                onTap: widget.onSortPressed,
                child: Row(
                  children: [
                    Icon(Icons.tune),
                    Text(widget.sortByRegistrationDate ? "등록일 순" : "가나다 순"),
                  ],
                ),
              ),
              if (widget.namecardCnt != 0)
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/businesscard/map');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFCCCCCC),
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
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
                ),
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

class _ExchangeCardListBodyState extends State<ExchangeCardListBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("_ExchangeCardListBodyState");
    print("교환 명함 길이" + widget.myExchangeItems.length.toString());

    return Container(
        child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.myExchangeItems.length,
      itemBuilder: (context, index) {
        NameCard data = widget.myExchangeItems[index];
        String namecardName = data.name;
        String namecardJob = data.job;
        String namecardImage = data.namecardImg;
        String namecardCompany = data.company;
        String namecardDateTime = data.exchangeDate;
        bool favorite = data.isFavorite;
        int exchangeSeq = data.exchangeSeq;
        String updateStatus = data.updateStatus;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenHeight * 0.04,
            vertical: screenWidth * 0.01,
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/businesscard/detail',
                arguments: {
                  'exchangeSeq': data.exchangeSeq,
                  'additionalData': data.updateStatus,
                },
              );
            },
            child: CustomListItem(
                name: namecardName,
                image: namecardImage,
                job: namecardJob,
                company: namecardCompany,
                dateTime: namecardDateTime,
                favorite: favorite,
                exchangeSeq: exchangeSeq,
                updateStatus: updateStatus),
          ),
        );
      },
    ));
  }
}

class CustomListItem extends StatefulWidget {
  const CustomListItem(
      {Key? key,
      required this.name,
      required this.image,
      required this.job,
      required this.company,
      required this.dateTime,
      required this.favorite,
      required this.exchangeSeq,
      required this.updateStatus})
      : super(key: key);

  final String name;
  final String image;
  final String job;
  final String company;
  final String dateTime;
  final bool favorite;
  final int exchangeSeq;
  final String updateStatus;

  @override
  State<CustomListItem> createState() => _CustomListItem();
}

class _CustomListItem extends State<CustomListItem> {
  ApiService apiService = ApiService();

  void makeFavorite() async {
    final response = await apiService.postRawRequest("namecard-service/like",
        widget.exchangeSeq.toString(), TokenManager().accessToken);
    print("_CustomListItem : makeFavorite");
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/main", (route) => false, arguments: 1);
    } else {
      throw Exception('Failed to load');
    }
  }

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
                      widget.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        makeFavorite();
                      },
                      child: widget.favorite
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
                    widget.job,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF858585),
                    ),
                  ),
                ),
                Text(
                  widget.company,
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
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Image.network(widget.image, fit: BoxFit.cover),
                ),
                if (widget.updateStatus == "UPDATED" ||
                    widget.updateStatus == "NEWLY")
                  Positioned(
                    top: 1,
                    left: 1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.redAccent),
                    ),
                  )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
