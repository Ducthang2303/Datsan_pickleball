import 'package:flutter/material.dart';
import '../constants/colors.dart';
class StarScreen extends StatelessWidget {
  final List<Map<String, String>> news = [
    {
      "title": "Giải đấu Pickleball Quốc tế 2024",
      "image": "assets/images/Tin1.jpg",
      "description": "Giải đấu Pickleball đang thu hút sự quan tâm từ các vận động viên toàn cầu...",
    },
    {
      "title": "Pickleball - Môn thể thao phát triển nhanh nhất",
      "image": "assets/images/Tin2.jpg",
      "description": "Pickleball đang trở thành xu hướng hot với số lượng người chơi tăng mạnh...",
    },
    {
      "title": "Những kỹ thuật nâng cao trong Pickleball",
      "image": "assets/images/Tin3.jpg",
      "description": "Cùng tìm hiểu những kỹ thuật giúp bạn nâng cao trình độ chơi Pickleball...",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tin tức Pickleball",style: TextStyle(color: AppColors.textColor),),
        backgroundColor: AppColors.Blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final item = news[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(item["image"]!, fit: BoxFit.cover, width: double.infinity, height: 150),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["title"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(item["description"]!, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
