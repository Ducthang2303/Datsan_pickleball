import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickleball/models/hoa_don.dart';

class HoaDonService {
  final CollectionReference hoaDonCollection = FirebaseFirestore.instance.collection('HOA_DON');
  final CollectionReference lichSanCollection = FirebaseFirestore.instance.collection('SAN_KHUNGGIO');

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
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Step 1: Read all required SAN_KHUNGGIO documents upfront
        Map<String, DocumentSnapshot> lichSanDocs = {};
        for (var kg in khungGio) {
          String docId = '${maSan}_${kg.ngay}';
          DocumentReference lichSanRef = lichSanCollection.doc(docId);
          DocumentSnapshot lichSanDoc = await transaction.get(lichSanRef);
          if (!lichSanDoc.exists) {
            throw Exception('Không tìm thấy khung giờ cho sân $maSan vào ngày ${kg.ngay}');
          }
          lichSanDocs[docId] = lichSanDoc;
        }

        // Step 2: Prepare updates for SAN_KHUNGGIO
        Map<String, List<dynamic>> updatedKhungGioLists = {};
        for (var kg in khungGio) {
          String docId = '${maSan}_${kg.ngay}';
          DocumentSnapshot lichSanDoc = lichSanDocs[docId]!;
          Map<String, dynamic> data = lichSanDoc.data() as Map<String, dynamic>;
          List<dynamic> khungGioList = List.from(data['KHUNG_GIO'] as List<dynamic>);

          bool updated = false;
          for (int i = 0; i < khungGioList.length; i++) {
            if (khungGioList[i]['gioBatDau'] == kg.gioBatDau &&
                khungGioList[i]['gioKetThuc'] == kg.gioKetThuc &&
                khungGioList[i]['trangThai'] == 0) { // Only update if Available
              khungGioList[i]['trangThai'] = 3; // Set to Pending
              updated = true;
            }
          }

          if (!updated) {
            throw Exception('Khung giờ ${kg.gioBatDau}-${kg.gioKetThuc} ngày ${kg.ngay} đã được chọn hoặc không khả dụng');
          }
          updatedKhungGioLists[docId] = khungGioList;
        }

        // Step 3: Write to HOA_DON
        DocumentReference hoaDonRef = hoaDonCollection.doc();
        transaction.set(hoaDonRef, {
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
          'pendingTimeout': Timestamp.fromDate(DateTime.now().add(Duration(minutes: 30))),
        });

        // Step 4: Write updates to SAN_KHUNGGIO
        updatedKhungGioLists.forEach((docId, khungGioList) {
          transaction.update(lichSanCollection.doc(docId), {'KHUNG_GIO': khungGioList});
        });
      });
    } catch (e) {
      print('Lỗi khi tạo hóa đơn: $e');
      rethrow;
    }
  }

  Future<void> updateHoaDonStatus(String id, String trangThai) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference hoaDonRef = hoaDonCollection.doc(id);
        DocumentSnapshot hoaDonDoc = await transaction.get(hoaDonRef);

        if (!hoaDonDoc.exists) {
          throw Exception('Hóa đơn không tồn tại');
        }

        Map<String, dynamic> data = hoaDonDoc.data() as Map<String, dynamic>;
        String maSan = data['maSan'];
        List<dynamic> khungGioList = data['khungGio'];

        // Update invoice status
        transaction.update(hoaDonRef, {
          'trangThai': trangThai,
          'pendingTimeout': null, // Clear timeout on status change
        });

        // Update time slot statuses
        for (var kg in khungGioList) {
          String docId = '${maSan}_${kg['ngay']}';
          DocumentReference lichSanRef = lichSanCollection.doc(docId);
          DocumentSnapshot lichSanDoc = await transaction.get(lichSanRef);

          if (lichSanDoc.exists) {
            Map<String, dynamic> lichSanData = lichSanDoc.data() as Map<String, dynamic>;
            List<dynamic> sanKhungGioList = lichSanData['KHUNG_GIO'] as List<dynamic>;

            bool updated = false;
            for (int i = 0; i < sanKhungGioList.length; i++) {
              if (sanKhungGioList[i]['gioBatDau'] == kg['gioBatDau'] &&
                  sanKhungGioList[i]['gioKetThuc'] == kg['gioKetThuc'] &&
                  sanKhungGioList[i]['trangThai'] == 3) { // Only update Pending slots
                sanKhungGioList[i]['trangThai'] = trangThai == 'Đã xác nhận' ? 1 : 0;
                updated = true;
              }
            }

            if (updated) {
              transaction.update(lichSanRef, {'KHUNG_GIO': sanKhungGioList});
            }
          }
        }
      });
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái hóa đơn: $e');
      rethrow;
    }
  }

  Future<void> revertPendingStatuses() async {
    try {
      QuerySnapshot pendingInvoices = await hoaDonCollection
          .where('trangThai', isEqualTo: 'Chờ xác nhận')
          .where('pendingTimeout', isLessThanOrEqualTo: Timestamp.now())
          .get();

      for (var doc in pendingInvoices.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String maSan = data['maSan'];
        List<dynamic> khungGioList = data['khungGio'];

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference hoaDonRef = hoaDonCollection.doc(doc.id);
          transaction.update(hoaDonRef, {
            'trangThai': 'Đã hủy',
            'pendingTimeout': null,
          });

          for (var kg in khungGioList) {
            String docId = '${maSan}_${kg['ngay']}';
            DocumentReference lichSanRef = lichSanCollection.doc(docId);
            DocumentSnapshot lichSanDoc = await transaction.get(lichSanRef);

            if (lichSanDoc.exists) {
              Map<String, dynamic> lichSanData = lichSanDoc.data() as Map<String, dynamic>;
              List<dynamic> sanKhungGioList = lichSanData['KHUNG_GIO'] as List<dynamic>;

              bool updated = false;
              for (int i = 0; i < sanKhungGioList.length; i++) {
                if (sanKhungGioList[i]['gioBatDau'] == kg['gioBatDau'] &&
                    sanKhungGioList[i]['gioKetThuc'] == kg['gioKetThuc'] &&
                    sanKhungGioList[i]['trangThai'] == 3) {
                  sanKhungGioList[i]['trangThai'] = 0;
                  updated = true;
                }
              }

              if (updated) {
                transaction.update(lichSanRef, {'KHUNG_GIO': sanKhungGioList});
              }
            }
          }
        });
      }
    } catch (e) {
      print('Lỗi khi hủy hóa đơn quá hạn: $e');
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
      final QuerySnapshot result = await hoaDonCollection
          .orderBy('thoiGianTao', descending: true)
          .get();

      final List<HoaDon> hoaDons = result.docs.map((doc) {
        return HoaDon.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      return hoaDons.where((hoaDon) {
        return hoaDon.khungGio.any((kg) => kg.ngay == ngay);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy hóa đơn theo ngày: $e');
      rethrow;
    }
  }

  Future<List<HoaDon>> getHoaDonByUserAndStatus(String maNguoiDung, String trangThai) async {
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
}