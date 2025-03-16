class ThanhToan {
  final int thanhToanId;
  final int datSanId;
  final double soTien;
  final String phuongThucThanhToan;
  final String? maGiaoDich;
  final DateTime ngayThanhToan;
  final String trangThai;

  ThanhToan({
    required this.thanhToanId,
    required this.datSanId,
    required this.soTien,
    required this.phuongThucThanhToan,
    this.maGiaoDich,
    required this.ngayThanhToan,
    required this.trangThai,
  });

  factory ThanhToan.fromJson(Map<String, dynamic> json) {
    return ThanhToan(
      thanhToanId: json['THANH_TOAN_ID'],
      datSanId: json['DAT_SAN_ID'],
      soTien: json['SO_TIEN'].toDouble(),
      phuongThucThanhToan: json['PHUONG_THUC_THANH_TOAN'],
      maGiaoDich: json['MA_GIAO_DICH'],
      ngayThanhToan: DateTime.parse(json['NGAY_THANH_TOAN']),
      trangThai: json['TRANG_THAI'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'THANH_TOAN_ID': thanhToanId,
      'DAT_SAN_ID': datSanId,
      'SO_TIEN': soTien,
      'PHUONG_THUC_THANH_TOAN': phuongThucThanhToan,
      'MA_GIAO_DICH': maGiaoDich,
      'NGAY_THANH_TOAN': ngayThanhToan.toIso8601String(),
      'TRANG_THAI': trangThai,
    };
  }
}