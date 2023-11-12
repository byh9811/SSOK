class RecognizedRegCard {
  final String registrationCardName;
  final String registrationCardPersonalNumber;
  final String registrationCardAddress;
  final String registrationCardIssueDate;
  final String registrationCardAuthority;

  RecognizedRegCard(
      {required this.registrationCardName,
      required this.registrationCardPersonalNumber,
      required this.registrationCardAddress,
      required this.registrationCardIssueDate,
      required this.registrationCardAuthority});
}
