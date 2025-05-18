import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickleball/models/hoa_don.dart';
import 'package:pickleball/constants/colors.dart'; // Assuming AppColors is defined here

class HoaDonDetailScreen extends StatelessWidget {
  final HoaDon hoaDon;

  const HoaDonDetailScreen({Key? key, required this.hoaDon}) : super(key: key);

  // Format currency for display
  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }

  // Get color based on invoice status
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
      appBar: AppBar(
        title: Text(
          'Chi tiết hóa đơn',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.Blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${hoaDon.tenSan} - ${hoaDon.tenKhu}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(hoaDon.trangThai).withOpacity(0.2),
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
                    SizedBox(height: 8),
                    Text(
                      'Mã hóa đơn: ${hoaDon.id}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Thời gian tạo: ${(hoaDon.thoiGianTao)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // User Info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin người đặt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 16),
                    Text(
                      'Họ tên: ${hoaDon.hoTenNguoiDung}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),

                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Time Slots
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khung giờ đặt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 16),
                    ...hoaDon.khungGio.asMap().entries.map((entry) {
                      int idx = entry.key;
                      KhungGioHoaDon khungGio = entry.value;
                      String displayDate = DateFormat('dd/MM/yyyy')
                          .format(DateFormat('yyyy-MM-dd').parse(khungGio.ngay));
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Ngày ${idx + 1}: $displayDate',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Giờ ${idx + 1}: ${khungGio.gioBatDau} - ${khungGio.gioKetThuc}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Price and Payment
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng tiền:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          _formatCurrency(hoaDon.giaTien),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.Blue,
                          ),
                        ),
                      ],
                    ),
                    if (hoaDon.anhChuyenKhoan != null && hoaDon.anhChuyenKhoan!.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        'Ảnh chuyển khoản:',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Optional: Open full-screen image viewer
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: InteractiveViewer(
                                child: Image.network(
                                  hoaDon.anhChuyenKhoan!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Center(child: Text('Không tải được ảnh')),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          hoaDon.anhChuyenKhoan!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(child: Text('Không tải được ảnh')),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}