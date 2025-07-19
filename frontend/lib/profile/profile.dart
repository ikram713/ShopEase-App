import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditProfilePage.dart';
import 'package:ecommerce_app/theme/theme_provider.dart';
import 'package:ecommerce_app/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final url = Uri.parse('http://10.44.197.181:5000/api/profile/get');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = data['user'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load profile")),
      );
    }
  }

  Future<void> pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _selectedImage = File(image.path));

    // Upload to Cloudinary
    final uploadUrl = Uri.parse("https://api.cloudinary.com/v1_1/dvgzdapkd/image/upload");


    final request = http.MultipartRequest("POST", uploadUrl)
      ..fields['upload_preset'] = "ecommerceApp"
      ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(resBody);
      final imageUrl = data['secure_url'];
      await sendImageUrlToBackend(imageUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cloudinary upload failed")),
      );
    }
  }

  Future<void> sendImageUrlToBackend(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final url = Uri.parse("http://10.44.197.181:5000/api/profile/avatar");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "avatar": imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Profile picture updated"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      fetchUserProfile(); // refresh updated image
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backend update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile", 
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFFFC727)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined ,
              color: Color(0xFFFFC727),
            ),
            onPressed: () {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Change Language'),
              onTap: () {
                Navigator.pop(context);
                // TODO: implement language switching logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Language change clicked")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Change Theme'),
              onTap: () {
                Navigator.pop(context);
                themeNotifier.value = 
                      themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Theme change clicked")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // remove userId and others
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out")),
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            ),
          ],
        ),
      );
    },
  );
},

          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        "User not found",
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                              backgroundImage: user!['avatar'] != null
                                  ? NetworkImage(user!['avatar'])
                                  : null,
                              child: user!['avatar'] == null
                                  ? Text(
                                      user!['username'][0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 40, 
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFC727),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFFFC727),
                                width: 3,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 20 ,),
                              color: Colors.white,
                              onPressed: pickAndUploadImage,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        user!['username'],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user!['email'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            _buildProfileItem(
                              context,
                              icon: Icons.person_outline,
                              title: "Username",
                              value: user!['username'],
                            ),
                            const Divider(height: 1, indent: 16),
                            _buildProfileItem(
                              context,
                              icon: Icons.email_outlined,                             
                              title: "Email",
                              value: user!['email'],
                            ),
                            if (user!['phone'] != null) ...[
                              const Divider(height: 1, indent: 16),
                              _buildProfileItem(
                                context,
                                icon: Icons.phone_outlined,
                                title: "Phone",
                                value: user!['phone'],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(user: user!),
                              ),
                            ).then((_) => fetchUserProfile());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFC727),
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xFFFFC727)),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}