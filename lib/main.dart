import 'package:flutter/material.dart';
import 'package:pickleball/views/Dang_nhap/dang_nhap.dart';
import 'models/nguoi_dung.dart';
import 'views/Tai_khoan/tai_khoan.dart';
import 'views/ban_do.dart';
import '/views/ds_khu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/Tin_tuc/tin_tuc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF0047AB)),
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final NguoiDung user;

  MainScreen({required this.user});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      MapScreen(),
      PickleballListScreen(user: widget.user),
      StarScreen(),
      AccountScreen(user: widget.user),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0047AB),
        selectedItemColor: Color(0xFFFFB703),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Nổi bật'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}



class EmptyScreen extends StatelessWidget {
  final String title;

  EmptyScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child: Text('Trang $title đang phát triển')),
    );
  }
}