import 'package:flutter/material.dart';
import 'package:pickleball/models/khu.dart';
import 'package:pickleball/models/nguoi_dung.dart';
import 'package:pickleball/models/san.dart';
import 'package:pickleball/services/san_khu_service.dart';
import 'package:pickleball/screens/Dat_san/chon_khung_gio.dart';

class ChonSanScreen extends StatefulWidget {
  final Khu khu;
  final NguoiDung user;
  ChonSanScreen({required this.khu, required this.user});

  @override
  _ChonLichScreenState createState() => _ChonLichScreenState();
}

class _ChonLichScreenState extends State<ChonSanScreen> {
  final SanKhuService _sanKhuService = SanKhuService();
  List<San> _sanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSanList();
  }

  Future<void> _fetchSanList() async {
    List<San> sanList = await _sanKhuService.getSanByKhu(widget.khu.ma);
    setState(() {
      _sanList = sanList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn sân - ${widget.khu.ten}"),
        backgroundColor: Color(0xFF0047AB),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _sanList.isEmpty
          ? Center(child: Text("Không có sân nào trong khu này."))
          : ListView.builder(
        itemCount: _sanList.length,
        itemBuilder: (context, index) {
          var san = _sanList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            color: Color(0xFFECECEC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                san.ten,
                style: TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                san.trangThai ? "Sân đang hoạt động" : "Sân đang bảo trì",
                style: TextStyle(
                  color: san.trangThai ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChonKhungGioScreen(san: san, user: widget.user, khu: widget.khu ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFB703)),
                child: Text('CHỌN'),
              ),

            ),
          );
        },
      ),
    );
  }
}
