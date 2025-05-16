import 'package:flutter/material.dart';
import '../../models/nguoi_dung.dart';
import 'dart:io';
import 'package:pickleball/constants/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickleball/services/upload_anh.dart';
import 'package:pickleball/services/sua_thong_tin.dart'; // Thêm dòng này

class SuaThongTinScreen extends StatefulWidget {
  final NguoiDung user;

  SuaThongTinScreen({required this.user});

  @override
  _SuaThongTinScreenState createState() => _SuaThongTinScreenState();
}

class _SuaThongTinScreenState extends State<SuaThongTinScreen> {
  late TextEditingController _tenController;
  late TextEditingController _sdtController;
  File? _selectedImage;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();

  final NguoiDungService _nguoiDungService = NguoiDungService(); // Service

  @override
  void initState() {
    super.initState();
    _tenController = TextEditingController(text: widget.user.hoTen);
    _sdtController = TextEditingController(text: widget.user.soDienThoai);
    _uploadedImageUrl = widget.user.anhDaiDien;
  }

  @override
  void dispose() {
    _tenController.dispose();
    _sdtController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
        final uploadedUrl = await CloudinaryService.uploadImage(_selectedImage!);
        if (uploadedUrl != null) {
          setState(() => _uploadedImageUrl = uploadedUrl);
        } else {
          _showMessage("Không thể tải ảnh lên.");
        }
      }
    } catch (e) {
      _showMessage("Lỗi chọn ảnh: $e");
    }
  }

  Future<void> _saveChanges() async {
    try {
      final NguoiDung updatedUser = NguoiDung(
        id: widget.user.id,
        hoTen: _tenController.text.trim(),
        email: widget.user.email,
        soDienThoai: _sdtController.text.trim(),
        anhDaiDien: _uploadedImageUrl ?? '', tenDangNhap: '', vaiTro: '',
      );

      await _nguoiDungService.capNhatThongTinNguoiDung(updatedUser);

      _showMessage("Cập nhật thành công");
      Navigator.pop(context, true);
    } catch (e) {
      _showMessage("Lỗi khi cập nhật: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Chỉnh sửa tài khoản',style: TextStyle(color: AppColors.textColor),),backgroundColor: AppColors.Blue,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty
                        ? NetworkImage(_uploadedImageUrl!)
                        : AssetImage("assets/avatar.png") as ImageProvider,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 16,
                    child: Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _tenController,
              decoration: InputDecoration(labelText: 'Họ tên'),
            ),
            TextField(
              controller: _sdtController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.Blue),
              ),
              onPressed: _saveChanges,
              child: Text('Lưu thay đổi',style: TextStyle(color: AppColors.textColor),),
            ),
          ],
        ),
      ),
    );
  }
}
