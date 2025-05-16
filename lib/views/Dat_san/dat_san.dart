import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickleball/models/khung_gio.dart';
import 'package:pickleball/models/nguoi_dung.dart';
import 'package:pickleball/models/san.dart';
import 'package:intl/intl.dart';
import 'package:pickleball/services/hoa_don.dart';
import 'package:pickleball/services/upload_anh.dart';
import '../../models/khu.dart';
import '../../models/hoa_don.dart';

class DatSanScreen extends StatefulWidget {
  final San san;
  final Khu khu;
  final List<Map<String, dynamic>> timeSlots;
  final NguoiDung user;

  DatSanScreen({
    required this.san,
    required this.khu,
    required this.timeSlots,
    required this.user,
  });

  @override
  State<DatSanScreen> createState() => _DatSanScreenState();
}

class _DatSanScreenState extends State<DatSanScreen> {
  final HoaDonService _hoaDonService = HoaDonService();
  File? _selectedImage;
  String? _uploadedImageUrl;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() => _selectedImage = imageFile);

      String? url = await CloudinaryService.uploadImage(imageFile);
      if (url != null) {
        setState(() => _uploadedImageUrl = url);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải ảnh thành công'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải ảnh thất bại'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleBookingConfirmation() async {
    if (_uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng tải lên ảnh đã chuyển khoản'), backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator(color: Color(0xFF0047AB))),
      );

      int totalPrice = widget.timeSlots.fold<int>(
        0,
            (int sum, slot) => sum + (slot['khungGio'].giaTien as int),
      );
      List<KhungGioHoaDon> khungGioHoaDon = widget.timeSlots.map((slot) {
        KhungGio khungGio = slot['khungGio'];
        return KhungGioHoaDon(
          ngay: slot['ngay'],
          gioBatDau: khungGio.gioBatDau,
          gioKetThuc: khungGio.gioKetThuc,
        );
      }).toList();

      await _hoaDonService.taoHoaDon(
        maNguoiDung: widget.user.id,
        hoTenNguoiDung: widget.user.hoTen,
        maSan: widget.san.ma,
        maKhu: widget.khu.id,
        tenSan: widget.san.ten,
        tenKhu: widget.khu.ten,
        khungGio: khungGioHoaDon,
        giaTien: totalPrice,
        anhChuyenKhoan: _uploadedImageUrl,
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đặt sân thành công!"), backgroundColor: Colors.green),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi đặt sân: ${e.toString()}"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    int totalPrice = widget.timeSlots.fold<int>(
      0,
          (int sum, slot) => sum + (slot['khungGio'].giaTien as int),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Đặt sân"), backgroundColor: Color(0xFF0047AB)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(Icons.sports_tennis, size: 48, color: Color(0xFF0047AB)),
                    SizedBox(height: 16),
                    Text("Thông tin đặt sân", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0047AB))),
                  ],
                ),
              ),
              SizedBox(height: 24),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow("Sân:", widget.san.ten),
                      Divider(),
                      _buildInfoRow("Người đặt:", widget.user.hoTen),
                      Divider(),
                      ...widget.timeSlots.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var slot = entry.value;
                        KhungGio khungGio = slot['khungGio'];
                        String ngay = slot['ngay'];
                        String displayDate = DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(ngay));
                        return Column(
                          children: [
                            _buildInfoRow("Ngày ${idx + 1}:", displayDate),
                            Divider(),
                            _buildInfoRow("Giờ ${idx + 1}:", "${khungGio.gioBatDau} - ${khungGio.gioKetThuc}"),
                            if (idx < widget.timeSlots.length - 1) Divider(),
                          ],
                        );
                      }).toList(),
                      _buildInfoRow("Tổng giá tiền:", formatCurrency.format(totalPrice), isHighlighted: true),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              Text("Quét mã QR để thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0047AB))),
              SizedBox(height: 12),
              Center(
                child: Image.asset('assets/images/qr/qr.jpg', width: 180),
              ),

              SizedBox(height: 24),
              Text("Tải ảnh xác nhận chuyển khoản", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0047AB))),
              SizedBox(height: 12),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200)
                  : Text("Chưa chọn ảnh", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload),
                label: Text("Tải ảnh từ thư viện"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0047AB),
                  foregroundColor: Colors.white,
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleBookingConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB703),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("XÁC NHẬN ĐẶT SÂN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Color(0xFF0047AB) : Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }
}