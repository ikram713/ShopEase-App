import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePageService {
  // Fetch items from API
  Future<List> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.93.89.181:5000/api/items/items'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load items');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Get user ID from SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Like or unlike a product
  Future<bool?> toggleLikeProduct(String userId, String productId) async {
    final url = Uri.parse('http://10.93.89.181:5000/api/like');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'productId': productId}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['liked'];
    } else {
      print('Failed to like product: ${response.body}');
      return null;
    }
  }
}
