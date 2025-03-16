class DatSan {
  final int datSanId;
  final int nguoiDungId;
  final int lichTrinhId;
  final DateTime ngayDat;
  final String trangThai;
  final String trangThaiThanhToan;
  final double soTien;
  final String? ghiChu;

  DatSan({
    required this.datSanId,
    required this.nguoiDungId,
    required this.lichTrinhId,
    required this.ngayDat,
    required this.trangThai,
    required this.trangThaiThanhToan,
    required this.soTien,
    this.ghiChu,
  });

  factory DatSan.fromJson(Map<String, dynamic> json) {
    return DatSan(
      datSanId: json['DAT_SAN_ID'],
      nguoiDungId: json['NGUOI_DUNG_ID'],
      lichTrinhId: json['LICH_TRINH_ID'],
      ngayDat: DateTime.parse(json['NGAY_DAT']),
      trangThai: json['TRANG_THAI'],
      trangThaiThanhToan: json['TRANG_THAI_THANH_TOAN'],
      soTien: json['SO_TIEN'].toDouble(),
      ghiChu: json['GHI_CHU'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DAT_SAN_ID': datSanId,
      'NGUOI_DUNG_ID': nguoiDungId,
      'LICH_TRINH_ID': lichTrinhId,
      'NGAY_DAT': ngayDat.toIso8601String(),
      'TRANG_THAI': trangThai,
      'TRANG_THAI_THANH_TOAN': trangThaiThanhToan,
      'SO_TIEN': soTien,
      'GHI_CHU': ghiChu,
    };
  }
}