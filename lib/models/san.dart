class San {
  String id;
  String ma;
  String maKhu;
  String ten;
  bool trangThai;

  San({
    required this.id,
    required this.ma,
    required this.maKhu,
    required this.ten,
    required this.trangThai,
  });


  factory San.fromMap(Map<String, dynamic> data, String documentId) {
    return San(
      id: documentId,
      ma: data['MA'] ?? '',
      maKhu: data['MA_KHU'] ?? '',
      ten: data['TEN'] ?? '',
      trangThai: data['TRANG_THAI'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MA': ma,
      'MA_KHU': maKhu,
      'TEN': ten,
      'TRANG_THAI': trangThai,
    };
  }
}
