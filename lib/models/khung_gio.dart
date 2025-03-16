class KhungGio {
  final int khungGioId;
  final String gioBatDau;
  final String gioKetThuc;

  KhungGio({
    required this.khungGioId,
    required this.gioBatDau,
    required this.gioKetThuc,
  });

  factory KhungGio.fromJson(Map<String, dynamic> json) {
    return KhungGio(
      khungGioId: json['KHUNG_GIO_ID'],
      gioBatDau: json['GIO_BAT_DAU'],
      gioKetThuc: json['GIO_KET_THUC'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KHUNG_GIO_ID': khungGioId,
      'GIO_BAT_DAU': gioBatDau,
      'GIO_KET_THUC': gioKetThuc,
    };
  }
}