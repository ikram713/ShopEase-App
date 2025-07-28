// lib/services/cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static Future<List<dynamic>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) throw Exception("User not logged in");

    final url = Uri.parse('http://10.93.89.181:5000/api/cart/get');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['cart'];
    } else {
      throw Exception('Failed to load cart');
    }
  }

  static double calculateTotal(List<dynamic> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      final product = item['itemId'];
      total += (product['price'] * item['quantity']);
    }
    return total;
  }
}
