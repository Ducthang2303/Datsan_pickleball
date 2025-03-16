class NguoiDung {
  final int nguoiDungId;
  final String tenDangNhap;
  final String hoTen;
  final String email;
  final String soDienThoai;
  final String vaiTro;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  NguoiDung({
    required this.nguoiDungId,
    required this.tenDangNhap,
    required this.hoTen,
    required this.email,
    required this.soDienThoai,
    required this.vaiTro,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      nguoiDungId: json['NGUOI_DUNG_ID'],
      tenDangNhap: json['TEN_DANG_NHAP'],
      hoTen: json['HO_TEN'],
      email: json['EMAIL'],
      soDienThoai: json['SO_DIEN_THOAI'],
      vaiTro: json['VAI_TRO'],
      ngayTao: DateTime.parse(json['NGAY_TAO']),
      ngayCapNhat: DateTime.parse(json['NGAY_CAP_NHAT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NGUOI_DUNG_ID': nguoiDungId,
      'TEN_DANG_NHAP': tenDangNhap,
      'HO_TEN': hoTen,
      'EMAIL': email,
      'SO_DIEN_THOAI': soDienThoai,
      'VAI_TRO': vaiTro,
      'NGAY_TAO': ngayTao.toIso8601String(),
      'NGAY_CAP_NHAT': ngayCapNhat.toIso8601String(),
    };
  }
}