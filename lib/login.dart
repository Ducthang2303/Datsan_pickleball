import 'package:flutter/material.dart';
import 'signup.dart'; // Import màn hình đăng ký nếu cần

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Đổi màu nền thành trắng
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tiêu đề
                Text(
                  "Đăng nhập - Khách",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0047AB),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "ALOBO - Đặt lịch online sân thể thao",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 30),

                // Nhập số điện thoại / email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Số điện thoại hoặc email",
                    hintText: "Nhập số điện thoại hoặc email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF0047AB)),
                  ),
                ),
                SizedBox(height: 15),

                // Nhập mật khẩu
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Nhập mật khẩu",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF0047AB)),
                    suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),

                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Xử lý quên mật khẩu
                    },
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(color: Color(0xFF0047AB)),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Nút đăng nhập
                ElevatedButton(
                  onPressed: () {
                    // Xử lý đăng nhập
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0047AB),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  child: Text(
                    "ĐĂNG NHẬP",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Đăng ký tài khoản
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bạn chưa có tài khoản?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Đăng ký ngay.",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0047AB)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
