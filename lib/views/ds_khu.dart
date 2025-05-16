import 'package:flutter/material.dart';
import '../services/san_khu_service.dart';
import '../models/khu.dart';
import 'package:pickleball/views/Dat_san/chon_san.dart';
import 'package:pickleball/models/nguoi_dung.dart';

class PickleballListScreen extends StatefulWidget {
  final NguoiDung user;

  PickleballListScreen({required this.user});
  @override
  _PickleballListScreenState createState() => _PickleballListScreenState();
}

class _PickleballListScreenState extends State<PickleballListScreen> {
  final SanKhuService _sanKhuService = SanKhuService();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  List<Khu> _khuList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKhuList();
  }

  Future<void> _fetchKhuList() async {
    List<Khu> khuList = await _sanKhuService.getAllKhu();
    setState(() {
      _khuList = khuList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Khu> filteredKhuList = _khuList
        .where((khu) => khu.ten.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0047AB),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tìm kiếm khu...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredKhuList.length,
        itemBuilder: (context, index) {
          var khu = filteredKhuList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            color: Color(0xFFECECEC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                khu.ten,
                style: TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                khu.diachi.isNotEmpty ? khu.diachi : "Không có địa chỉ",
                style: TextStyle(color: Color(0xFF555555)),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChonSanScreen(khu: khu,user:widget.user),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFB703)),
                child: Text('XEM SÂN'),
              ),
            ),
          );
        },
      ),
    );
  }
}
