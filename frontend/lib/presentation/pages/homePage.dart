import 'package:ecommerce_app/data/services/homePage_service.dart';
import 'package:ecommerce_app/presentation/pages/details.dart';
import 'package:flutter/material.dart';
import '../widgets/item_search_delegate.dart';
import 'package:ecommerce_app/presentation/pages/cart.dart';
import 'package:ecommerce_app/presentation/profile/profile.dart';
import 'package:ecommerce_app/presentation/pages/favorites.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  int selectedIndex = -1;

  List<Map<String, dynamic>> categories = [
    {"icon": Icons.laptop, "label": "Laptop"},
    {"icon": Icons.watch, "label": "Watch"},
    {"icon": Icons.electric_bike_outlined, "label": "Bike"},
    {"icon": Icons.headphones, "label": "Headphones"},
    {"icon": Icons.phone_android, "label": "Phone"},
  ];

  List items = [];
  List<bool> isLikedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

// Fetch items from the API
 

void fetchItems() async {
  final homePageService = HomePageService();
  final result = await homePageService.fetchItems();
  if (mounted) {
    setState(() {
      items = result;
      isLikedList = List.generate(items.length, (_) => false);
      isLoading = false;
    });
  }
}

Future<void> likeProduct(String productId, int index) async {
  final homePageService = HomePageService();
  final userId = await homePageService.getUserId();
  if (userId == null) {
    print("User not logged in");
    return;
  }

  final liked = await homePageService.toggleLikeProduct(userId, productId);
  if (liked != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(liked ? 'Product added to favorites' : 'Product removed from favorites'),
        backgroundColor: liked ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    setState(() => isLikedList[index] = liked);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     bottomNavigationBar: Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 1,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: const Color(0xFFFFC727),
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        height: 1.5,  // Better vertical spacing
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.5,
      ),
      iconSize: 26,  // Slightly more compact
      elevation: 0,  // Remove default elevation
      backgroundColor: Colors.white,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.home_outlined),
          ),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.home),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.shopping_bag),
          ),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.favorite_border),
          ),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.favorite),
          ),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.person_outline),
          ),
          activeIcon: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Icon(Icons.person),
          ),
          label: "Profile",
        ),
      ],
    ),
  ),
),
      body: SafeArea(
        child: _currentIndex == 0
            ? SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    GestureDetector(
                      onTap: () {
                        showSearch(context: context, delegate: ItemSearchDelegate());
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 10),
                            Text("Search", style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Categories
                    Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: isSelected ? const Color(0xFFFFC727) : Colors.grey[200],
                                    ),
                                    height: 80,
                                    width: 80,
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      categories[index]["icon"],
                                      size: 45,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    categories[index]["label"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 30),
                    Text("Best Selling", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),

                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            itemCount: items.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 270,
                            ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final isLiked = index < isLikedList.length && isLikedList[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ItemsDetails(data: item)),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          color: Colors.grey[200],
                                          width: double.infinity,
                                          child: Image.network(
                                            item["image"] ?? '',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Icon(Icons.broken_image),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["name"] ?? "No name",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              item["description"] ?? "No description",
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "\$${item["price"].toString()}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xFFFFC727),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                                    color: isLiked ? Color(0xFFFFC727) : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                   final productId = items[index]['_id']; // or item['_id']
                                                    likeProduct(productId, index);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              )
              : _currentIndex == 1
              ? CartPage()
              : _currentIndex == 2
              ? FavoritesPage()
              : ProfilePage(),
          ),
      );
  }
}
