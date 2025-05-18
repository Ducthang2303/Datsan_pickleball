import 'package:flutter/material.dart';
import 'package:pickleball/models/khung_gio.dart';
import 'package:pickleball/models/nguoi_dung.dart';
import 'package:pickleball/services/san_khu_service.dart';
import 'package:pickleball/models/san_khunggio.dart';
import 'package:pickleball/models/san.dart';
import 'package:intl/intl.dart';
import 'package:pickleball/views/Dat_san/dat_san.dart';
import '../../models/khu.dart';

class ChonKhungGioScreen extends StatefulWidget {
  final San san;
  final Khu khu;
  final NguoiDung user;

  ChonKhungGioScreen({required this.san, required this.user, required this.khu});

  @override
  _ChonKhungGioScreenState createState() => _ChonKhungGioScreenState();
}

class _ChonKhungGioScreenState extends State<ChonKhungGioScreen> {
  final SanKhuService _sanKhuService = SanKhuService();
  Map<String, List<KhungGio>> _khungGioByDate = {};
  bool _isLoading = true;
  List<DateTime> selectedDates = [DateTime.now()];
  List<Map<String, dynamic>> selectedTimeSlots = [];
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _fetchKhungGioList();
  }

  Future<void> _fetchKhungGioList() async {
    setState(() {
      _isLoading = true;
    });

    _khungGioByDate.clear();
    DateTime now = DateTime.now();

    for (DateTime date in selectedDates) {
      String ngay = DateFormat('yyyy-MM-dd').format(date);
      try {
        List<SanKhungGio> result = await _sanKhuService.getKhungGioBySan(widget.san.ma, ngay);

        if (result.isNotEmpty && result[0].khungGio.isNotEmpty) {
          if (DateFormat('yyyy-MM-dd').format(now) == ngay) {
            for (int i = 0; i < result[0].khungGio.length; i++) {
              KhungGio khungGio = result[0].khungGio[i];
              List<String> startTimeParts = khungGio.gioBatDau.split(':');
              if (startTimeParts.length >= 2) {
                int startHour = int.tryParse(startTimeParts[0]) ?? 0;
                int startMinute = int.tryParse(startTimeParts[1]) ?? 0;
                DateTime slotStartTime = DateTime(now.year, now.month, now.day, startHour, startMinute);
                if (now.isAfter(slotStartTime)) {
                  result[0].khungGio[i].trangThai = 2;
                }
              }
            }
          }
          _khungGioByDate[ngay] = result[0].khungGio;
        } else {
          _khungGioByDate[ngay] = [];
        }
      } catch (e) {
        print("Lỗi khi lấy khung giờ cho $ngay: $e");
        _khungGioByDate[ngay] = [];
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDates(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF0047AB),
            colorScheme: ColorScheme.light(primary: Color(0xFF0047AB)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && !selectedDates.contains(picked)) {
      setState(() {
        selectedDates.add(picked);
        selectedDates.sort();
      });
      _fetchKhungGioList();
    }
  }

  void _removeDate(DateTime date) {
    setState(() {
      selectedDates.remove(date);
      String ngay = DateFormat('yyyy-MM-dd').format(date);
      _khungGioByDate.remove(ngay);
      selectedTimeSlots.removeWhere((slot) => slot['ngay'] == ngay);
    });
    if (selectedDates.isEmpty) {
      selectedDates.add(DateTime.now());
    }
    _fetchKhungGioList();
  }

  void _handleTimeSlotPressed(KhungGio khungGio, String ngay) {
    setState(() {
      int index = selectedTimeSlots.indexWhere(
            (slot) =>
        slot['ngay'] == ngay &&
            slot['khungGio'].gioBatDau == khungGio.gioBatDau &&
            slot['khungGio'].gioKetThuc == khungGio.gioKetThuc,
      );

      if (index != -1) {
        selectedTimeSlots.removeAt(index);
      } else {
        selectedTimeSlots.add({
          'ngay': ngay,
          'khungGio': khungGio,
        });
      }
    });
  }

  void _confirmSelection() {
    if (selectedTimeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ít nhất một khung giờ'), backgroundColor: Colors.orange),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DatSanScreen(
          san: widget.san,
          khu: widget.khu,
          timeSlots: selectedTimeSlots,
          user: widget.user,
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(KhungGio khungGio, String ngay) {
    Color backgroundColor;
    String statusText;
    bool isBookable;
    bool isSelected = selectedTimeSlots.any(
          (slot) =>
      slot['ngay'] == ngay &&
          slot['khungGio'].gioBatDau == khungGio.gioBatDau &&
          slot['khungGio'].gioKetThuc == khungGio.gioKetThuc,
    );

    switch (khungGio.trangThai) {
      case 0:
        backgroundColor = isSelected ? Color(0xFF4CAF50) : Color(0xFFC8E6C9);
        statusText = "Còn trống";
        isBookable = true;
        break;
      case 1:
        backgroundColor = Color(0xFFE7DBB4);
        statusText = "Đã đặt";
        isBookable = false;
        break;
      case 2:
        backgroundColor = Color(0xFFEEAAAA);
        statusText = "Đã khóa";
        isBookable = false;
        break;
      case 3:
        backgroundColor = Color(0xFFFFDAB9);
        statusText = "Đang chờ duyệt";
        isBookable = false;
        break;
      default:
        backgroundColor = Color(0xFFECECEC);
        statusText = "Còn trống";
        isBookable = true;
    }

    return InkWell(
      onTap: isBookable ? () => _handleTimeSlotPressed(khungGio, ngay) : null,
      child: Card(
        margin: EdgeInsets.all(6.0),
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isBookable ? 2 : 1,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${khungGio.gioBatDau} - ${khungGio.gioKetThuc}",
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isBookable ? Colors.green.withOpacity(0.1) : (khungGio.trangThai == 3 ? Colors.orange.withOpacity(0.3) : Colors.red.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: khungGio.trangThai == 3 ? Colors.orange[900] : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = selectedTimeSlots.fold<int>(
      0,
          (int sum, slot) => sum + (slot['khungGio'].giaTien as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn khung giờ - ${widget.san.ten}"),
        backgroundColor: Color(0xFF0047AB),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chọn ngày",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0047AB),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _selectDates(context),
                      icon: Icon(Icons.calendar_today, size: 18),
                      label: Text("Thêm ngày"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0047AB),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: selectedDates.map((date) {
                    return Chip(
                      label: Text(DateFormat('dd/MM/yyyy').format(date)),
                      onDeleted: () => _removeDate(date),
                      deleteIcon: Icon(Icons.close, size: 18),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF0047AB)))
                : _khungGioByDate.isEmpty
                ? Center(
              child: Text(
                "Không có khung giờ nào khả dụng",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: _khungGioByDate.keys.length,
              itemBuilder: (context, index) {
                String ngay = _khungGioByDate.keys.elementAt(index);
                List<KhungGio> khungGioList = _khungGioByDate[ngay]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Ngày: ${DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(ngay))}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0047AB),
                        ),
                      ),
                    ),
                    if (khungGioList.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Không có khung giờ khả dụng",
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: khungGioList.length,
                        itemBuilder: (context, idx) {
                          return _buildTimeSlotCard(khungGioList[idx], ngay);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
          if (selectedTimeSlots.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng giá",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0047AB),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formatCurrency.format(totalPrice),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0047AB),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFB703),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        "XÁC NHẬN LỰA CHỌN",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}