import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsDetails extends StatefulWidget {
  final dynamic data;

  const ItemsDetails({super.key, required this.data});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 👈 Get current theme

    return Scaffold(
      endDrawer: EndDrawerButton(),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 28, color: theme.iconTheme.color),
            const SizedBox(width: 5),
            Text(
              "Detail",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Mart",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD2A210),
              ),
            ),
          ],
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Product Image
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.cardColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.data['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Product Name
          Text(
            widget.data['name'],
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Product Description
          Text(
            widget.data['description'],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Product Price
          Text(
            '${widget.data['price']}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFC727),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Color options
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Color: ",
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              _buildColorCircle(Colors.grey, selected: true),
              const SizedBox(width: 5),
              Text("Grey", style: theme.textTheme.bodyMedium),
              const SizedBox(width: 15),
              _buildColorCircle(Colors.black),
              const SizedBox(width: 5),
              Text("Black", style: theme.textTheme.bodyMedium),
            ],
          ),

          const SizedBox(height: 20),

          // Size Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Size: ",
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              ...[38, 39, 40, 41, 42].map((size) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Chip(
                      label: Text("$size"),
                      backgroundColor: theme.cardColor,
                      shape: StadiumBorder(
                        side: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 30),

          // Add to Cart Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getString('userId');

                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please login first")),
                    );
                    return;
                  }

                  final itemId = widget.data['_id'];
                  final url = Uri.parse('http://10.44.197.181:5000/api/cart/add');

                  try {
                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'userId': userId, 'itemId': itemId}),
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.data['name']} added to cart!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to add to cart")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Something went wrong")),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Add to Cart", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC727),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color, {bool selected = false}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: selected
            ? Border.all(color: const Color(0xFFFFC727), width: 2)
            : null,
      ),
    );
  }
}
