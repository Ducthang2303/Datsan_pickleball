class LichTrinhSan {
  final int lichTrinhId;
  final int sanId;
  final DateTime ngay;
  final int thu;
  final int khungGioId;
  final bool conTrong;
  final double? giaDacBiet;

  LichTrinhSan({
    required this.lichTrinhId,
    required this.sanId,
    required this.ngay,
    required this.thu,
    required this.khungGioId,
    required this.conTrong,
    this.giaDacBiet,
  });

  factory LichTrinhSan.fromJson(Map<String, dynamic> json) {
    return LichTrinhSan(
      lichTrinhId: json['LICH_TRINH_ID'],
      sanId: json['SAN_ID'],
      ngay: DateTime.parse(json['NGAY']),
      thu: json['THU'],
      khungGioId: json['KHUNG_GIO_ID'],
      conTrong: json['CON_TRONG'] == 1,
      giaDacBiet: json['GIA_DAC_BIET']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LICH_TRINH_ID': lichTrinhId,
      'SAN_ID': sanId,
      'NGAY': ngay.toIso8601String().split('T')[0],
      'THU': thu,
      'KHUNG_GIO_ID': khungGioId,
      'CON_TRONG': conTrong ? 1 : 0,
      'GIA_DAC_BIET': giaDacBiet,
    };
  }
}