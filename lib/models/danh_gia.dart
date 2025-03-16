class DanhGia {
  final int danhGiaId;
  final int datSanId;
  final int soSao;
  final String? binhLuan;
  final DateTime ngayTao;

  DanhGia({
    required this.danhGiaId,
    required this.datSanId,
    required this.soSao,
    this.binhLuan,
    required this.ngayTao,
  });

  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      danhGiaId: json['DANH_GIA_ID'],
      datSanId: json['DAT_SAN_ID'],
      soSao: json['SO_SAO'],
      binhLuan: json['BINH_LUAN'],
      ngayTao: DateTime.parse(json['NGAY_TAO']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DANH_GIA_ID': danhGiaId,
      'DAT_SAN_ID': datSanId,
      'SO_SAO': soSao,
      'BINH_LUAN': binhLuan,
      'NGAY_TAO': ngayTao.toIso8601String(),
    };
  }
}