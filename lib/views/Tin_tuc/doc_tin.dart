import 'package:flutter/material.dart';
import 'package:pickleball/constants/colors.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const NewsDetailScreen({
    Key? key,
    required this.title,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.Blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Image.asset(
              image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: 250,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: Center(child: Text('Hình ảnh không tải được')),
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor2,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Optional: Add placeholder for more content
                  Text(
                    'Nội dung chi tiết có thể được mở rộng tại đây...',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}