import 'package:flutter/material.dart';
import 'package:ssok/widgets/modals/business_transfer_modal.dart';

class RegisteredBusinessCard extends StatefulWidget {
  const RegisteredBusinessCard({super.key});

  @override
  State<RegisteredBusinessCard> createState() => _RegisteredBusinessCardState();
}

class _RegisteredBusinessCardState extends State<RegisteredBusinessCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyBusinessCard(),
        BusinessCardList(),
      ],
    );
  }
}

class MyBusinessCard extends StatelessWidget {
  const MyBusinessCard({
    Key? key,
  }) : super(key: key);

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
                          child: BusinessTransferModal(),
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
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/businesscard/my");
            },
            child: AspectRatio(
              aspectRatio: 9 / 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.amber,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BusinessCardList extends StatefulWidget {
  const BusinessCardList({super.key});

  @override
  State<BusinessCardList> createState() => _BusinessCardListState();
}

class _BusinessCardListState extends State<BusinessCardList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        BusinessCardListHeader(),
        BusinessCardListBody(),
      ],
    );
  }
}

class BusinessCardListHeader extends StatefulWidget {
  const BusinessCardListHeader({super.key});

  @override
  State<BusinessCardListHeader> createState() => _BusinessCardListHeaderState();
}

class _BusinessCardListHeaderState extends State<BusinessCardListHeader> {
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
                "전체(0)",
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

class BusinessCardListBody extends StatefulWidget {
  const BusinessCardListBody({super.key});

  @override
  State<BusinessCardListBody> createState() => _BusinessCardListBodyState();
}

class _BusinessCardListBodyState extends State<BusinessCardListBody> {
  List<Map<String, dynamic>> businessCardList = [
    {
      'namecardName': '김기아',
      'namecardImage': '',
      'namecardJob': "키마스터",
      'namecardCompany': "기아 미소대리점",
      'namecardDateTime': '2023-11-02 10:30:00',
    },
    {
      'namecardName': '홍길동',
      'namecardImage': '',
      'namecardJob': "엔지니어",
      'namecardCompany': "이나 인더스트리즈",
      'namecardDateTime': '2023-11-01 21:30:00',
    },
    {
      'namecardName': '김싸피',
      'namecardImage': '',
      'namecardJob': "컨설턴트",
      'namecardCompany': "SSAFY 멀티캠퍼스",
      'namecardDateTime': '2023-10-21 16:30:00',
    },
    {
      'namecardName': '김싸피',
      'namecardImage': '',
      'namecardJob': "컨설턴트",
      'namecardCompany': "SSAFY 멀티캠퍼스",
      'namecardDateTime': '2023-10-21 16:30:00',
    },
    {
      'namecardName': '김싸피',
      'namecardImage': '',
      'namecardJob': "컨설턴트",
      'namecardCompany': "SSAFY 멀티캠퍼스",
      'namecardDateTime': '2023-10-21 16:30:00',
    },
    {
      'namecardName': '김싸피',
      'namecardImage': '',
      'namecardJob': "컨설턴트",
      'namecardCompany': "SSAFY 멀티캠퍼스",
      'namecardDateTime': '2023-10-21 16:30:00',
    },
  ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.482,
      child: ListView.builder(
        itemCount: businessCardList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = businessCardList[index];

          String namecardName = data['namecardName'];
          String namecardJob = data['namecardJob'];
          String namecardCompany = data['namecardCompany'];
          String namecardDateTime = data['namecardDateTime'];

          return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenHeight * 0.04,
                vertical: screenWidth * 0.01,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/businesscard/detail');
                },
                child: CustomListItem(
                  name: namecardName,
                  image: "",
                  job: namecardJob,
                  company: namecardCompany,
                  dateTime: namecardDateTime,
                ),
              ));
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
  }) : super(key: key);

  final String name;
  final String image;
  final String job;
  final String company;
  final String dateTime;

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
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
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
                  color: Colors.amber,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
