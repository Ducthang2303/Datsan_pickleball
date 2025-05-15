import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nguoi_dung.dart';

class NguoiDungService {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('NGUOIDUNG');

  // Cập nhật thông tin người dùng
  Future<void> capNhatThongTinNguoiDung(NguoiDung nguoiDung) async {
    try {
      await _usersCollection.doc(nguoiDung.id).update({
        'ANH_DAI_DIEN': nguoiDung.anhDaiDien,
        'HO_TEN': nguoiDung.hoTen,
        'SO_DIEN_THOAI': nguoiDung.soDienThoai,
      });
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thông tin: $e');
    }
  }
}
