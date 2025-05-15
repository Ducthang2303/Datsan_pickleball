import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nguoi_dung.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập & lấy thông tin người dùng từ Firestore
  Future<NguoiDung?> signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseAuth.instance.setLanguageCode("vi");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception("Người dùng không tồn tại.");
      }

      String uid = user.uid;

      // Lấy thông tin user từ Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection("NGUOIDUNG").doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("Không tìm thấy dữ liệu người dùng.");
      }

      return NguoiDung.fromMap(uid, userDoc.data()!);
    } catch (e) {
      throw Exception("Lỗi đăng nhập: ${e.toString()}");
    }
  }
}
