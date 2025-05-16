import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickleball/views/Dang_nhap/dang_nhap.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String fullName = _fullNameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage("Vui lòng điền đầy đủ thông tin.");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("Mật khẩu không khớp.");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection("NGUOIDUNG").doc(uid).set({
        "EMAIL": email,
        "HO_TEN": fullName,
        "SO_DIEN_THOAI": "",
        "TEN_DANG_NHAP": email.split("@")[0],
        "VAI_TRO": "Người dùng",
        "TRANG_THAI": "Hoạt động",
        "NGAY_TAO": FieldValue.serverTimestamp(),
      });

      _showMessage("Đăng ký thành công!", isSuccess: true);


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      _showMessage("Lỗi đăng ký: $e");
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

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
                Text("Đăng ký", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 10),
                Text("Đặt lịch online sân thể thao"),
                SizedBox(height: 20),

                _buildTextField("Số điện thoại hoặc email", _emailController, false),
                _buildTextField("Tên đầy đủ", _fullNameController, false),
                _buildTextField("Mật khẩu", _passwordController, true),
                _buildTextField("Nhập lại mật khẩu", _confirmPasswordController, true),

                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
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
                    child: Text("Bạn đã có tài khoản? Đăng nhập", style: TextStyle(color: Color(0xFF0047AB))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
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
