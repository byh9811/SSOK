class RecognizedLicense {
  final String licenseName;
  final String licensePersonalNumber;
  final String licenseType;
  final String licenseAddress;
  final String licenseNumber;
  final String licenseRenewStartDate;
  final String licenseRenewEndDate;
  final String licenseCondition;
  final String licenseCode;
  final String licenseIssueDate;
  final String licenseAuthority;

  RecognizedLicense(
      {required this.licenseName,
      required this.licensePersonalNumber,
      required this.licenseType,
      required this.licenseAddress,
      required this.licenseNumber,
      required this.licenseRenewStartDate,
      required this.licenseRenewEndDate,
      required this.licenseCondition,
      required this.licenseCode,
      required this.licenseIssueDate,
      required this.licenseAuthority});
}
