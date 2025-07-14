import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details.dart';

class ItemSearchDelegate extends SearchDelegate {
  Future<List<dynamic>> searchItems(String query) async {
    final url = Uri.parse('http://10.44.197.181:5000/search?query=${Uri.encodeComponent(query)}');
    print("🔍 Searching: $url");

    try {
      final response = await http.get(url);

      print("✅ Status Code: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Server error");
        return [];
      }
    } catch (e) {
      print("❌ Error during search: $e");
      return [];
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: searchItems(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No results found."));
        }

        final results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];

            return ListTile(
              leading: item["image"] != null
                  ? Image.network(item["image"], width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image_not_supported),
              title: Text(item["name"] ?? "No name"),
              subtitle: Text(item["description"] ?? ""),
              onTap: () {
                close(context, null); // close search
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ItemsDetails(data: item)),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
Widget buildSuggestions(BuildContext context) {
  if (query.isEmpty) {
    return Center(child: Text("Type to search items..."));
  }

  return FutureBuilder<List<dynamic>>(
    future: searchItems(query),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text("No suggestions found."));
      }

      final suggestions = snapshot.data!;

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final item = suggestions[index];

          return ListTile(
            leading: item["image"] != null
                ? Image.network(item["image"], width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.image),
            title: Text(item["name"] ?? "No name"),
            onTap: () {
              query = item["name"]; // fills the search field with the selected suggestion
              showResults(context); // triggers buildResults
            },
          );
        },
      );
    },
  );
}


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}
