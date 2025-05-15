import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickleball/models/hoa_don.dart';

class HoaDonService {
  final CollectionReference hoaDonCollection =
  FirebaseFirestore.instance.collection('HOA_DON');

  Future<void> taoHoaDon({
    required String maNguoiDung,
    required String hoTenNguoiDung,
    required String maKhu,
    required String maSan,
    required String tenSan,
    required String tenKhu,
    required List<KhungGioHoaDon> khungGio,
    required int giaTien,
    required String? anhChuyenKhoan,
  }) async {
    try {
      await hoaDonCollection.add({
        'maNguoiDung': maNguoiDung,
        'hoTenNguoiDung': hoTenNguoiDung,
        'maKhu': maKhu,
        'maSan': maSan,
        'tenSan': tenSan,
        'tenKhu': tenKhu,
        'khungGio': khungGio.map((item) => item.toMap()).toList(),
        'giaTien': giaTien,
        'anhChuyenKhoan': anhChuyenKhoan,
        'thoiGianTao': FieldValue.serverTimestamp(),
        'trangThai': 'Chờ xác nhận',
      });
    } catch (e) {
      print('Lỗi khi tạo hóa đơn: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getAllHoaDon() async {
    try {
      final QuerySnapshot result = await hoaDonCollection
          .orderBy('thoiGianTao', descending: true)
          .get();

      return result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy tất cả hóa đơn: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getHoaDonByUser(String maNguoiDung) async {
    try {
      final QuerySnapshot result = await hoaDonCollection
          .where('maNguoiDung', isEqualTo: maNguoiDung)
          .orderBy('thoiGianTao', descending: true)
          .get();

      return result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy hóa đơn: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getHoaDonByStatus(String trangThai) async {
    try {
      final QuerySnapshot result = await hoaDonCollection
          .where('trangThai', isEqualTo: trangThai)
          .orderBy('thoiGianTao', descending: true)
          .get();

      return result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy hóa đơn theo trạng thái: $e');
      rethrow;
    }
  }

  Future<HoaDon?> getHoaDonById(String id) async {
    try {
      final DocumentSnapshot doc = await hoaDonCollection.doc(id).get();

      if (doc.exists) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy hóa đơn theo ID: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getHoaDonBySan(String maSan) async {
    try {
      final QuerySnapshot result = await hoaDonCollection
          .where('maSan', isEqualTo: maSan)
          .orderBy('thoiGianTao', descending: true)
          .get();

      return result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy hóa đơn theo sân: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getHoaDonByDate(String ngay) async {
    try {
      // Since khungGio is a list, we need to fetch all documents and filter client-side
      final QuerySnapshot result = await hoaDonCollection
          .orderBy('thoiGianTao', descending: true)
          .get();

      final List<HoaDon> hoaDons = result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Filter invoices where any khungGio entry matches the date
      return hoaDons.where((hoaDon) {
        return hoaDon.khungGio.any((kg) => kg.ngay == ngay);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy hóa đơn theo ngày: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getHoaDonByUserAndStatus(
      String maNguoiDung, String trangThai) async {
    try {
      final QuerySnapshot result = await hoaDonCollection
          .where('maNguoiDung', isEqualTo: maNguoiDung)
          .where('trangThai', isEqualTo: trangThai)
          .orderBy('thoiGianTao', descending: true)
          .get();

      return result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy hóa đơn theo người dùng và trạng thái: $e');
      rethrow;
    }
  }

  Future<void> updateHoaDonStatus(String id, String trangThai) async {
    try {
      await hoaDonCollection.doc(id).update({
        'trangThai': trangThai,
      });
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái hóa đơn: $e');
      rethrow;
    }
  }
}