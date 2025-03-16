class San {
  final int sanId;
  final String tenSan;
  final String? moTa;
  final String trangThai;
  final double giaTheoGio;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  San({
    required this.sanId,
    required this.tenSan,
    this.moTa,
    required this.trangThai,
    required this.giaTheoGio,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory San.fromJson(Map<String, dynamic> json) {
    return San(
      sanId: json['SAN_ID'],
      tenSan: json['TEN_SAN'],
      moTa: json['MO_TA'],
      trangThai: json['TRANG_THAI'],
      giaTheoGio: json['GIA_THEO_GIO'].toDouble(),
      ngayTao: DateTime.parse(json['NGAY_TAO']),
      ngayCapNhat: DateTime.parse(json['NGAY_CAP_NHAT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SAN_ID': sanId,
      'TEN_SAN': tenSan,
      'MO_TA': moTa,
      'TRANG_THAI': trangThai,
      'GIA_THEO_GIO': giaTheoGio,
      'NGAY_TAO': ngayTao.toIso8601String(),
      'NGAY_CAP_NHAT': ngayCapNhat.toIso8601String(),
    };
  }
}
