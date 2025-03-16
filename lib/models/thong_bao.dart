class ThongBao {
  final int thongBaoId;
  final int nguoiDungId;
  final String noiDung;
  final bool daDoc;
  final DateTime ngayTao;

  ThongBao({
    required this.thongBaoId,
    required this.nguoiDungId,
    required this.noiDung,
    required this.daDoc,
    required this.ngayTao,
  });

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      thongBaoId: json['THONG_BAO_ID'],
      nguoiDungId: json['NGUOI_DUNG_ID'],
      noiDung: json['NOI_DUNG'],
      daDoc: json['DA_DOC'] == 1,
      ngayTao: DateTime.parse(json['NGAY_TAO']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'THONG_BAO_ID': thongBaoId,
      'NGUOI_DUNG_ID': nguoiDungId,
      'NOI_DUNG': noiDung,
      'DA_DOC': daDoc ? 1 : 0,
      'NGAY_TAO': ngayTao.toIso8601String(),
    };
  }
}