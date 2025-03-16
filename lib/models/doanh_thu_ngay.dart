class DoanhThuNgay {
  final int doanhThuId;
  final DateTime ngay;
  final int tongLuotDat;
  final double tongDoanhThu;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  DoanhThuNgay({
    required this.doanhThuId,
    required this.ngay,
    required this.tongLuotDat,
    required this.tongDoanhThu,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory DoanhThuNgay.fromJson(Map<String, dynamic> json) {
    return DoanhThuNgay(
      doanhThuId: json['DOANH_THU_ID'],
      ngay: DateTime.parse(json['NGAY']),
      tongLuotDat: json['TONG_LUOT_DAT'],
      tongDoanhThu: json['TONG_DOANH_THU'].toDouble(),
      ngayTao: DateTime.parse(json['NGAY_TAO']),
      ngayCapNhat: DateTime.parse(json['NGAY_CAP_NHAT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DOANH_THU_ID': doanhThuId,
      'NGAY': ngay.toIso8601String().split('T')[0],
      'TONG_LUOT_DAT': tongLuotDat,
      'TONG_DOANH_THU': tongDoanhThu,
      'NGAY_TAO': ngayTao.toIso8601String(),
      'NGAY_CAP_NHAT': ngayCapNhat.toIso8601String(),
    };
  }
}