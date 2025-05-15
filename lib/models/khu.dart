class Khu {
  String id;
  String ma;
  String ten;
  String diachi;

  Khu({required this.id, required this.ma, required this.ten, required this.diachi});

  // Chuyển dữ liệu từ Firestore sang đối tượng Khu
  factory Khu.fromMap(Map<String, dynamic> data, String docId) {
    return Khu(
      id: docId,
      ma: data["MA"] ?? "",
      ten: data["TEN"] ?? "",
      diachi: data["DIA_CHI"] ?? "",
    );
  }

  // Chuyển đối tượng Khu thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      "MA": ma,
      "TEN": ten,
    };
  }
}
