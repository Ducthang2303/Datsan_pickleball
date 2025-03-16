class DoanhThuThang {
  final int doanhThuId;
  final int nam;
  final int thang;
  final int tongLuotDat;
  final double tongDoanhThu;
  final int soSanSuDung;
  final double giaTriTrungBinhMoiLuot;
  final int? sanPhoBienNhatId;
  final int? khungGioPhoBienNhatId;
  final double? tyLeTangTruong;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;

  DoanhThuThang({
    required this.doanhThuId,
    required this.nam,
    required this.thang,
    required this.tongLuotDat,
    required this.tongDoanhThu,
    required this.soSanSuDung,
    required this.giaTriTrungBinhMoiLuot,
    this.sanPhoBienNhatId,
    this.khungGioPhoBienNhatId,
    this.tyLeTangTruong,
    required this.ngayTao,
    required this.ngayCapNhat,
  });

  factory DoanhThuThang.fromJson(Map<String, dynamic> json) {
    return DoanhThuThang(
      doanhThuId: json['DOANH_THU_ID'],
      nam: json['NAM'],
      thang: json['THANG'],
      tongLuotDat: json['TONG_LUOT_DAT'],
      tongDoanhThu: json['TONG_DOANH_THU'].toDouble(),
      soSanSuDung: json['SO_SAN_SU_DUNG'],
      giaTriTrungBinhMoiLuot: json['GIA_TRI_TRUNG_BINH_MOI_LUOT'].toDouble(),
      sanPhoBienNhatId: json['SAN_PHO_BIEN_NHAT_ID'],
      khungGioPhoBienNhatId: json['KHUNG_GIO_PHO_BIEN_NHAT_ID'],
      tyLeTangTruong: json['TY_LE_TANG_TRUONG']?.toDouble(),
      ngayTao: DateTime.parse(json['NGAY_TAO']),
      ngayCapNhat: DateTime.parse(json['NGAY_CAP_NHAT']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DOANH_THU_ID': doanhThuId,
      'NAM': nam,
      'THANG': thang,
      'TONG_LUOT_DAT': tongLuotDat,
      'TONG_DOANH_THU': tongDoanhThu,
      'SO_SAN_SU_DUNG': soSanSuDung,
      'GIA_TRI_TRUNG_BINH_MOI_LUOT': giaTriTrungBinhMoiLuot,
      'SAN_PHO_BIEN_NHAT_ID': sanPhoBienNhatId,
      'KHUNG_GIO_PHO_BIEN_NHAT_ID': khungGioPhoBienNhatId,
      'TY_LE_TANG_TRUONG': tyLeTangTruong,
      'NGAY_TAO': ngayTao.toIso8601String(),
      'NGAY_CAP_NHAT': ngayCapNhat.toIso8601String(),
    };
  }
}