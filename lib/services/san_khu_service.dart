import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/khung_gio.dart';
import '../models/san.dart';
import '../models/khu.dart';
import '../models/san_khunggio.dart';

class SanKhuService {
  final CollectionReference _sanCollection = FirebaseFirestore.instance
      .collection('SAN');
  final CollectionReference _khuCollection = FirebaseFirestore.instance
      .collection('KHU');
  final CollectionReference _lichSanCollection = FirebaseFirestore.instance
      .collection('SAN_KHUNGGIO');

  // 📌 Lấy danh sách khu
  Future<List<Khu>> getAllKhu() async {
    try {
      QuerySnapshot snapshot = await _khuCollection.get();
      return snapshot.docs.map((doc) =>
          Khu.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách khu: $e");
      return [];
    }
  }

  // 📌 Lấy danh sách sân
  Future<List<San>> getAllSan() async {
    try {
      QuerySnapshot snapshot = await _sanCollection.get();
      return snapshot.docs.map((doc) =>
          San.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách sân: $e");
      return [];
    }
  }

  // 📌 Lấy danh sách sân theo khu
  Future<List<San>> getSanByKhu(String maKhu) async {
    try {
      QuerySnapshot snapshot = await _sanCollection.where(
          'MA_KHU', isEqualTo: maKhu).get();
      return snapshot.docs.map((doc) =>
          San.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách sân theo khu: $e");
      return [];
    }
  }

  // 📌 Lấy danh sách khung giờ của một sân theo ngày
  Future<List<SanKhungGio>> getKhungGioBySan(String maSan, String ngay) async {
    try {
      QuerySnapshot snapshot = await _lichSanCollection
          .where('MA_SAN', isEqualTo: maSan)
          .where('NGAY', isEqualTo: ngay)
          .get();

      return snapshot.docs.map((doc) =>
          SanKhungGio.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Lỗi khi lấy khung giờ của sân $maSan vào ngày $ngay: $e");
      return [];
    }
  }
}