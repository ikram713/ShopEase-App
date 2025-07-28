import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  final String apiUrl = 'http://10.93.89.181:5000/api/get-likes';

  Future<List> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) throw Exception("User ID not found");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['favorites'] ?? [];
    } else {
      throw Exception("Failed to load favorites");
    }
  }
}
