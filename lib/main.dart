import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'location_service.dart';
import 'weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Cuaca',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final latController = TextEditingController();
  final lonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Masukkan Koordinat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: "Latitude",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(
                labelText: "Longitude",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final lat = double.tryParse(latController.text);
                final lon = double.tryParse(lonController.text);

                if (lat != null && lon != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeatherPage(
                        latitude: lat,
                        longitude: lon,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Masukkan angka valid")),
                  );
                }
              },
              child: const Text("Lihat Cuaca"),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String? placeName;
  List<WeatherModel> weatherList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final locationService = LocationService();
      final weatherService = WeatherService();

      final name =
          await locationService.getPlaceName(widget.latitude, widget.longitude);
      final list =
          await weatherService.fetchWeather(widget.latitude, widget.longitude);

      setState(() {
        placeName = name;
        weatherList = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        placeName = "Gagal memuat lokasi";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuaca Hari Ini")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Lokasi: $placeName",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: weatherList.length,
                    itemBuilder: (context, index) {
                      final weather = weatherList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.blueGrey),
                              Text(
                                weather.formattedTime,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          title: Row(
                            children: [
                              const Icon(Icons.thermostat, color: Colors.red),
                              const SizedBox(width: 6),
                              Text("${weather.temperature}°C"),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.water_drop,
                                      color: Colors.blue, size: 18),
                                  const SizedBox(width: 6),
                                  Text("Kelembaban: ${weather.humidity}%"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.air,
                                      color: Colors.green, size: 18),
                                  const SizedBox(width: 6),
                                  Text("Angin: ${weather.windspeed} km/jam"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
