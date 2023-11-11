class BusinessCardDataMap {

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
  final double lat;
  final double lon;

  BusinessCardDataMap({
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
    required this.lat,
    required this.lon
  });
  factory BusinessCardDataMap.fromJson(Map<String, dynamic> json) {
    return BusinessCardDataMap(
      exchangeSeq: json['exchangeSeq'] as int? ?? 0, // null 값이면 기본값 0으로 설정
      namecardName: json['namecardName'] as String? ?? '',
      namecardImage: json['namecardImage'] as String? ?? '',
      namecardEmail: json['namecardEmail'] as String? ?? '',
      namecardCompany: json['namecardCompany'] as String? ?? '',
      namecardJob: json['namecardJob'] as String? ?? '',
      namecardAddress: json['namecardAddress'] as String? ?? '',
      namecardPhone: json['namecardPhone'] as String? ?? '',
      namecardFax: json['namecardFax'] as String? ?? '',
      namecardWebsite: json['namecardWebsite'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false, // null 값이면 기본값 false로 설정
      exchangeNote: json['exchangeNote'] as String? ?? '',
      lat: json['lat'] as double? ?? 0.0, // null 값이면 기본값 0.0으로 설정
      lon: json['lon'] as double? ?? 0.0,
    );
  }
}
