import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0047AB),
      body: Column(
        children: [
          SizedBox(height: 40), // ✅ Thêm khoảng cách phía trên

          // Phần trên - Avatar + Tiêu đề nằm ngang
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"), // Hình nền phía sau
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/avatar.png"),
                ),
                SizedBox(width: 10),

                // Văn bản
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " Đặt lịch online sân thể thao",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Tạo tài khoản để dễ dàng quản lý lịch đặt",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Nút Đăng nhập & Đăng ký
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB703),
                  foregroundColor: Color(0xFF555555),
                ),
                child: Text("Đăng nhập"),
              ),
              SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                child: Text("Đăng ký"),
              ),
            ],
          ),

          SizedBox(height: 20), // ✅ Thêm khoảng cách phía dưới

          // Phần lịch đặt của bạn
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Lịch đặt của bạn",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Bạn chưa có lịch đặt nào!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Thanh điều hướng dưới cùng

    );
  }
}
