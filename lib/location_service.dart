import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  Future<String> getPlaceName(double latitude, double longitude) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["display_name"] ?? "Nama tempat tidak ditemukan";
    } else {
      throw Exception("Gagal memuat lokasi");
    }
  }
}
