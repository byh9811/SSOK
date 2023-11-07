class BusinessCardData {
  final int namecardSeq;
  final String namecardImg;
  final List<Namecard> namecards;

  BusinessCardData({
    required this.namecardSeq,
    required this.namecardImg,
    required this.namecards,
  });

  factory BusinessCardData.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      // 'json'이 null일 경우 초기화나 기본값을 반환
      return BusinessCardData(
        namecardSeq: 0,
        namecardImg: "",
        namecards: [],
      );
    }
    List<Namecard> namecards = List<Namecard>.from(
        (json['namecards'] as List).map((item) => Namecard.fromJson(item)));

    return BusinessCardData(
      namecardSeq: json['namecardSeq'],
      namecardImg: json['namecardImg'],
      namecards: namecards,
    );
  }
}

class Namecard {
  final int namecardSeq;
  final int memberSeq;
  final int exchangeSeq;
  final String namecardName;
  final String namecardImage;
  final String namecardEmail;
  final String namecardCompany;
  final String namecardJob;
  final String namecardAddress;
  final String namecardPhone;
  final String namecardFax;
  final String namecardWebsite;
  final bool isFavorite;
  final String exchangeNote;
  final String date;

  Namecard({
    required this.namecardSeq,
    required this.memberSeq,
    required this.exchangeSeq,
    required this.namecardName,
    required this.namecardImage,
    required this.namecardEmail,
    required this.namecardCompany,
    required this.namecardJob,
    required this.namecardAddress,
    required this.namecardPhone,
    required this.namecardFax,
    required this.namecardWebsite,
    required this.isFavorite,
    required this.exchangeNote,
    required this.date,
  });

  factory Namecard.fromJson(Map<String, dynamic> json) {
    return Namecard(
      namecardSeq: json['namecardSeq'],
      memberSeq: json['memberSeq'],
      exchangeSeq: json['exchangeSeq'],
      namecardName: json['namecardName'],
      namecardImage: json['namecardImage'],
      namecardEmail: json['namecardEmail'],
      namecardCompany: json['namecardCompany'],
      namecardJob: json['namecardJob'],
      namecardAddress: json['namecardAddress'],
      namecardPhone: json['namecardPhone'],
      namecardFax: json['namecardFax'],
      namecardWebsite: json['namecardWebsite'],
      isFavorite: json['isFavorite'],
      exchangeNote: json['exchangeNote'],
      date: json['date'],
    );
  }
}
