import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:pickleball/constants/colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _mapController = MapController();
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  LatLng? _startPoint;
  LatLng? _endPoint;
  double? _distance;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Search address using Nominatim API
  Future<LatLng?> _searchAddress(String address) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1');
    try {
      final response = await http.get(url, headers: {'User-Agent': 'PickleballApp/1.0'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
        } else {
          print('Nominatim: No results for address "$address"');
          return null;
        }
      } else {
        print('Nominatim: HTTP ${response.statusCode} for address "$address"');
        return null;
      }
    } catch (e) {
      print('Nominatim: Error searching address "$address": $e');
      return null;
    }
  }

  // Get route from GraphHopper API
  Future<void> _getRoute(LatLng start, LatLng end) async {
    const apiKey = 'af0e79a3-3040-4d7c-a7a9-399f9be8ffee'; // Replace with your GraphHopper API key
    final url = Uri.parse(
      'https://graphhopper.com/api/1/route?point=${start.latitude},${start.longitude}&point=${end.latitude},${end.longitude}&vehicle=car&points_encoded=true&key=$apiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['paths'] != null && data['paths'].isNotEmpty) {
          final polylineEncoded = data['paths'][0]['points'];
          final distanceInMeters = data['paths'][0]['distance'];
          final points = _decodePolyline(polylineEncoded);
          setState(() {
            _distance = distanceInMeters / 1000;
            _polylines = [
              Polyline(
                points: points,
                strokeWidth: 4.0,
                color: Colors.blue.withOpacity(0.7),
              ),
            ];
          });
        } else {
          throw Exception('No route found');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('GraphHopper: Error fetching route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching route: ${e.toString().contains('401') ? 'Invalid API key' : e.toString()}')),
      );
    }
  }

  // Decode GraphHopper polyline (encoded polyline format)
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // Calculate distance and update map
  Future<void> _calculateDistance() async {
    if (_startController.text.isEmpty || _endController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both addresses')),
      );
      return;
    }

    _startPoint = await _searchAddress(_startController.text);
    _endPoint = await _searchAddress(_endController.text);

    if (_startPoint == null || _endPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not find one or both addresses')),
      );
      return;
    }

    setState(() {
      _markers = [
        Marker(
          point: _startPoint!,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
        ),
        Marker(
          point: _endPoint!,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
        ),
      ];
    });

    // Fetch and display route
    await _getRoute(_startPoint!, _endPoint!);

    // Adjust camera to show both points
    if (_startPoint != null && _endPoint != null) {
      final bounds = LatLngBounds(_startPoint!, _endPoint!);
      final center = LatLng(
        (bounds.southWest.latitude + bounds.northEast.latitude) / 2,
        (bounds.southWest.longitude + bounds.northEast.longitude) / 2,
      );
      final distance = Geolocator.distanceBetween(
        bounds.southWest.latitude,
        bounds.southWest.longitude,
        bounds.northEast.latitude,
        bounds.northEast.longitude,
      );
      final zoom = (distance > 0 ? (15.0 - (distance / 10000).clamp(0.0, 10.0)) : 13.0).toDouble();

      _mapController.move(center, zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(21.0285, 105.8542), // Hanoi
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pickleball',
              ),
              MarkerLayer(markers: _markers),
              PolylineLayer(polylines: _polylines),
            ],
          ),
          // Collapsible Input UI
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: const Text(
                  'Tìm kiếm địa chỉ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                initiallyExpanded: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _startController,
                          decoration: InputDecoration(
                            hintText: 'Từ',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _endController,
                          decoration: InputDecoration(
                            hintText: 'Đến',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _calculateDistance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.Blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(double.infinity, 0),
                          ),
                          child: const Text('Chỉ đường', style: TextStyle(fontSize: 16)),
                        ),
                        if (_distance != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${_distance!.toStringAsFixed(2)} km',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}