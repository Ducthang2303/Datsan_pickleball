import 'package:flutter/material.dart';

class PickleballListScreen extends StatefulWidget {
  @override
  _PickleballListScreenState createState() => _PickleballListScreenState();
}

class _PickleballListScreenState extends State<PickleballListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  final List<Map<String, dynamic>> locations = [
    {'name': 'Pickleball Gamuda Sky', 'distance': '264.6m', 'address': 'Đường 2.4 Gamuda, phường Trần Phú, Hoàng Mai', 'rating': 5},
    {'name': 'CLB Pickleball CC5 GAMUDA Trần Phú', 'distance': '358.9m', 'address': 'Đường 2.2 Gamuda Trần Phú, Gamuda Gardens', 'rating': 5},
    {'name': 'Pickleball Gamuda', 'distance': '472.0m', 'address': 'Chung cư Gamuda, Trần Phú, Hoàng Mai', 'rating': 5},
    {'name': 'Taydo Pickleball', 'distance': '1.8km', 'address': 'Khu X2A, phường Yên Sở, quận Hoàng Mai', 'rating': 3},
    {'name': 'PICK VĨNH HOÀNG', 'distance': '1.8km', 'address': 'Phường Hoàng Văn Thụ, Quận Hoàng Mai', 'rating': 4},
    {'name': 'VNPickleball Khánh Duy', 'distance': '2.0km', 'address': 'XVG6+C59, Thịnh Liệt, Hoàng Mai', 'rating': 3},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredLocations = locations
        .where((location) => location['name'].toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0047AB),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tìm kiếm sân...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredLocations.length,
        itemBuilder: (context, index) {
          var location = filteredLocations[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            color: Color(0xFFECECEC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                location['name'],
                style: TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${location['distance']} - ${location['address']}',
                style: TextStyle(color: Color(0xFF555555)),
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFB703)),
                child: Text('ĐẶT LỊCH'),
              ),
            ),
          );
        },
      ),
    );
  }
}
