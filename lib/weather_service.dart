import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  Future<List<WeatherModel>> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast"
      "?latitude=$latitude&longitude=$longitude"
      "&hourly=temperature_2m,relativehumidity_2m,windspeed_10m"
      "&timezone=auto",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final times = jsonData['hourly']['time'] as List;

      List<WeatherModel> weatherList = [];

      DateTime now = DateTime.now();
      String today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      for (int i = 0; i < times.length; i++) {
        DateTime time = DateTime.parse(times[i]);
        if (time.toIso8601String().startsWith(today)) {
          weatherList.add(WeatherModel.fromJson(jsonData, i));
        }
      }

      return weatherList;
    } else {
      throw Exception("Gagal memuat data cuaca");
    }
  }
}
