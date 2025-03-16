import 'package:flutter/material.dart';
import '../screens/login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đăng ký",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(" Đặt lịch online sân thể thao"),
                SizedBox(height: 20),

                _buildTextField("Số điện thoại hoặc email", false),
                _buildTextField("Tên đầy đủ", false),
                _buildTextField("Mật khẩu", true),
                _buildTextField("Nhập lại mật khẩu", true),

                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0047AB),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("ĐĂNG KÝ"),
                  ),
                ),

                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text("Bạn đã có tài khoản? Đăng nhập",
                        style: TextStyle(color: Color(0xFF0047AB))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: isPassword ? (hint == "Mật khẩu" ? _obscurePassword : _obscureConfirmPassword) : false,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(hint == "Mật khẩu" ? (_obscurePassword ? Icons.visibility_off : Icons.visibility) : (_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility)),
            onPressed: () {
              setState(() {
                if (hint == "Mật khẩu") {
                  _obscurePassword = !_obscurePassword;
                } else {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                }
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
