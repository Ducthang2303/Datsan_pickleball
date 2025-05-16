class Khu {
  String id;
  String ma;
  String ten;
  String diachi;

  Khu({required this.id, required this.ma, required this.ten, required this.diachi});


  factory Khu.fromMap(Map<String, dynamic> data, String docId) {
    return Khu(
      id: docId,
      ma: data["MA"] ?? "",
      ten: data["TEN"] ?? "",
      diachi: data["DIA_CHI"] ?? "",
    );
  }


  Map<String, dynamic> toMap() {
    return {
      "MA": ma,
      "TEN": ten,
    };
  }
}
