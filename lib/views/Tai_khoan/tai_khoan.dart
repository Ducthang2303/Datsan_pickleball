import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pickleball/views/Tai_khoan/sua_thong_tin.dart';
import '../Dang_nhap/dang_nhap.dart';
import '../../models/nguoi_dung.dart';
import '../../models/hoa_don.dart';
import 'package:pickleball/services/hoa_don.dart';
import 'package:pickleball/views/Tai_khoan/chi_tiet_hoa_don.dart'; // Import the new screen

class AccountScreen extends StatefulWidget {
  final NguoiDung user;

  AccountScreen({required this.user});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with WidgetsBindingObserver {
  final HoaDonService _hoaDonService = HoaDonService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<HoaDon> _hoaDonList = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tất cả';
  final List<String> _filterOptions = ['Tất cả', 'Chờ xác nhận', 'Đã duyệt', 'Đã hủy'];
  late NguoiDung _currentUser;
  bool _wasInactive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentUser = widget.user;
    _loadHoaDon();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _wasInactive = true;
    } else if (state == AppLifecycleState.resumed && _wasInactive) {
      _refreshPage();
      _wasInactive = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      _refreshUserAndData();
    }
  }

  Future<void> _refreshUserAndData() async {
    try {
      User? currentAuthUser = FirebaseAuth.instance.currentUser;
      if (currentAuthUser != null) {
        await _refreshUserData(showLoadingState: false);
        await _loadHoaDon(showLoadingState: false);
      }
    } catch (e) {
      print('Silent refresh error: $e');
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _refreshUserData({bool showLoadingState = true}) async {
    try {
      User? currentAuthUser = FirebaseAuth.instance.currentUser;
      if (currentAuthUser == null) {
        throw Exception("Người dùng không đăng nhập.");
      }

      String uid = currentAuthUser.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection("NGUOIDUNG").doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("Không tìm thấy dữ liệu người dùng.");
      }

      setState(() {
        _currentUser = NguoiDung.fromMap(uid, userDoc.data()!);
      });
    } catch (e) {
      if (showLoadingState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật thông tin người dùng: $e')),
        );
      }
      throw e;
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _refreshUserData();
      await _loadHoaDon();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật trang'), duration: Duration(seconds: 1)),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    }
  }

  Future<void> _loadHoaDon({bool showLoadingState = true}) async {
    if (showLoadingState) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      List<HoaDon> hoaDonList;
      if (_selectedFilter == 'Tất cả') {
        hoaDonList = await _hoaDonService.getHoaDonByUser(_currentUser.id);
      } else {
        hoaDonList = await _hoaDonService.getHoaDonByUserAndStatus(
            _currentUser.id, _selectedFilter);
      }

      setState(() {
        _hoaDonList = hoaDonList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (showLoadingState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải hóa đơn: $e')),
        );
      }
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange;
      case 'Đã duyệt':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0047AB),
      body: Column(
        children: [
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _currentUser.anhDaiDien != null
                      ? NetworkImage(_currentUser.anhDaiDien!)
                      : AssetImage("assets/avatar.png") as ImageProvider,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser.hoTen,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _currentUser.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "SĐT: ${_currentUser.soDienThoai}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuaThongTinScreen(user: _currentUser),
                          ),
                        );
                        if (result != null && result is bool && result) {
                          _refreshPage();
                        }
                      },
                      tooltip: 'Sửa thông tin',
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () => _logout(context),
                      tooltip: 'Đăng xuất',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lịch đặt của bạn",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton<String>(
                        icon: Row(
                          children: [
                            Text(_selectedFilter,
                                style: TextStyle(color: Color(0xFF0047AB), fontSize: 14)),
                            Icon(Icons.filter_list, color: Color(0xFF0047AB)),
                          ],
                        ),
                        onSelected: (String filter) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                          _loadHoaDon();
                        },
                        itemBuilder: (BuildContext context) {
                          return _filterOptions.map((String filter) {
                            return PopupMenuItem<String>(
                              value: filter,
                              child: Text(filter),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _hoaDonList.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 60, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            "Bạn chưa có lịch đặt nào!",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refreshPage,
                            icon: Icon(Icons.refresh),
                            label: Text("Tải lại"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0047AB),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                        : RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: ListView.builder(
                        itemCount: _hoaDonList.length,
                        itemBuilder: (context, index) {
                          final HoaDon hoaDon = _hoaDonList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HoaDonDetailScreen(hoaDon: hoaDon),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color:
                                  _getStatusColor(hoaDon.trangThai).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${hoaDon.tenSan} - ${hoaDon.tenKhu}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(hoaDon.trangThai)
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            hoaDon.trangThai,
                                            style: TextStyle(
                                              color: _getStatusColor(hoaDon.trangThai),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(height: 16),
                                    // Display all time slots in khungGio
                                    ...hoaDon.khungGio.asMap().entries.map((entry) {
                                      int idx = entry.key;
                                      KhungGioHoaDon khungGio = entry.value;
                                      String displayDate = DateFormat('dd/MM/yyyy')
                                          .format(DateFormat('yyyy-MM-dd')
                                          .parse(khungGio.ngay));
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "Ngày ${idx + 1}: $displayDate",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "Giờ ${idx + 1}: ${khungGio.gioBatDau} - ${khungGio.gioKetThuc}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      );
                                    }).toList(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Giá: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(hoaDon.giaTien),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0047AB),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}