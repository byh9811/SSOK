class BusinessCardData {
  final int memberSeq;
  final List<MyNameCard> myNamecardItems;
  final List<NameCard> myExchangeItems;
  final List<NameCard> favorites;

  BusinessCardData({
    required this.memberSeq,
    required this.myNamecardItems,
    required this.myExchangeItems,
    required this.favorites,
  });

  factory BusinessCardData.fromJson(Map<String, dynamic> json) {
    List<MyNameCard> myNamecardItems = List<MyNameCard>.from(
        (json['myNamecardItems'] as List)
            .map((item) => MyNameCard.fromJson(item)));
    List<NameCard> myExchangeItems = List<NameCard>.from(
        (json['myExchangeItems'] as List)
            .map((item) => NameCard.fromJson(item)));
    List<NameCard> favorites = List<NameCard>.from(
        (json['favorites'] as List).map((item) => NameCard.fromJson(item)));

    return BusinessCardData(
        memberSeq: json["memberSeq"],
        myNamecardItems: myNamecardItems,
        myExchangeItems: myExchangeItems,
        favorites: favorites);
  }
}

class MyNameCard {
  final int namecardSeq;
  final String namecardName;
  final String namecardCompany;
  final String namecardJob;
  final String namecardImg;

  MyNameCard(
      {required this.namecardSeq,
      required this.namecardName,
      required this.namecardCompany,
      required this.namecardJob,
      required this.namecardImg});

  factory MyNameCard.fromJson(Map<String, dynamic> json) {
    return MyNameCard(
        namecardSeq: json["namecardSeq"],
        namecardName: json["namecardName"],
        namecardCompany: json["namecardCompany"],
        namecardJob: json["namecardJob"],
        namecardImg: json["namecardImg"]);
  }
}

class NameCard {
  final int exchangeSeq;
  final int namecardSeq;
  final int belongNamecardSeq;
  final String namecardImg;
  final String name;
  final String updateStatus;
  final String company;
  final String job;
  final String exchangeDate;
  final bool isFavorite;

  NameCard(
      {required this.exchangeSeq,
      required this.namecardSeq,
      required this.belongNamecardSeq,
      required this.namecardImg,
      required this.name,
      required this.updateStatus,
      required this.company,
      required this.job,
      required this.exchangeDate,
      required this.isFavorite});

  factory NameCard.fromJson(Map<String, dynamic> json) {
    return NameCard(
        exchangeSeq: json["exchangeSeq"],
        namecardSeq: json["namecardSeq"],
        belongNamecardSeq: json["belongNamecardSeq"],
        namecardImg: json["namecardImg"],
        name: json["name"],
        updateStatus: json["updateStatus"],
        company: json["company"],
        job: json["job"],
        exchangeDate: json["exchangeDate"],
        isFavorite: json["isFavorite"]);
  }
}
