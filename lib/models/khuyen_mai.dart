class KhuyenMai {
  final int khuyenMaiId;
  final String maKhuyenMai;
  final String? moTa;
  final String loaiGiamGia;
  final double giaTriGiamGia;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final bool dangHoatDong;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  KhuyenMai({
    required this.khuyenMaiId,
    required this.maKhuyenMai,
    this.moTa,
    required this.loaiGiamGia,
    required this.giaTriGiamGia,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.dangHoatDong,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory KhuyenMai.fromJson(Map<String, dynamic> json) {
    return KhuyenMai(
      khuyenMaiId: json['KHUYEN_MAI_ID'],
      maKhuyenMai: json['MA_KHUYEN_MAI'],
      moTa: json['MO_TA'],
      loaiGiamGia: json['LOAI_GIAM_GIA'],
      giaTriGiamGia: json['GIA_TRI_GIAM_GIA'].toDouble(),
      ngayBatDau: DateTime.parse(json['NGAY_BAT_DAU']),
      ngayKetThuc: DateTime.parse(json['NGAY_KET_THUC']),
      dangHoatDong: json['DANG_HOAT_DONG'] == 1,
      ngayTao: DateTime.parse(json['NGAY_TAO']),
      ngayCapNhat: DateTime.parse(json['NGAY_CAP_NHAT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KHUYEN_MAI_ID': khuyenMaiId,
      'MA_KHUYEN_MAI': maKhuyenMai,
      'MO_TA': moTa,
      'LOAI_GIAM_GIA': loaiGiamGia,
      'GIA_TRI_GIAM_GIA': giaTriGiamGia,
      'NGAY_BAT_DAU': ngayBatDau.toIso8601String().split('T')[0],
      'NGAY_KET_THUC': ngayKetThuc.toIso8601String().split('T')[0],
      'DANG_HOAT_DONG': dangHoatDong ? 1 : 0,
      'NGAY_TAO': ngayTao.toIso8601String(),
      'NGAY_CAP_NHAT': ngayCapNhat.toIso8601String(),
    };
  }
}