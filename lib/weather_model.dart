class WeatherModel {
  final double temperature;
  final int humidity;
  final double windspeed;
  final DateTime time;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windspeed,
    required this.time,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, int index) {
    return WeatherModel(
      temperature: (json['hourly']['temperature_2m'][index] as num).toDouble(),
      humidity: (json['hourly']['relativehumidity_2m'][index] as num).toInt(),
      windspeed: (json['hourly']['windspeed_10m'][index] as num).toDouble(),
      time: DateTime.parse(json['hourly']['time'][index]),
    );
  }

  String get formattedTime =>
      "${time.hour.toString().padLeft(2, '0')}:00";
}
