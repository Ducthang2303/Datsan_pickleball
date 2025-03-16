class DoanhThuSanTheoThang {
  final int doanhThuId;
  final int nam;
  final int thang;
  final int sanId;
  final int tongLuotDat;
  final double tongDoanhThu;
  final double tyLeSuDung;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  DoanhThuSanTheoThang({
    required this.doanhThuId,
    required this.nam,
    required this.thang,
    required this.sanId,
    required this.tongLuotDat,
    required this.tongDoanhThu,
    required this.tyLeSuDung,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory DoanhThuSanTheoThang.fromJson(Map<String, dynamic> json) {
    return DoanhThuSanTheoThang(
      doanhThuId: json['DOANH_THU_ID'],
      nam: json['NAM'],
      thang: json['THANG'],
      sanId: json['SAN_ID'],
      tongLuotDat: json['TONG_LUOT_DAT'],
      tongDoanhThu: json['TONG_DOANH_THU'].toDouble(),
      tyLeSuDung: json['TY_LE_SU_DUNG'].toDouble(),
      ngayTao: DateTime.parse(json['NGAY_TAO']),
      ngayCapNhat: DateTime.parse(json['NGAY_CAP_NHAT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DOANH_THU_ID': doanhThuId,
      'NAM': nam,
      'THANG': thang,
      'SAN_ID': sanId,
      'TONG_LUOT_DAT': tongLuotDat,
      'TONG_DOANH_THU': tongDoanhThu,
      'TY_LE_SU_DUNG': tyLeSuDung,
      'NGAY_TAO': ngayTao.toIso8601String(),
      'NGAY_CAP_NHAT': ngayCapNhat.toIso8601String(),
    };
  }
}