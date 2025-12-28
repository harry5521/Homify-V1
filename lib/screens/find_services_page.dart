import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_state.dart'; 

class FindServicesPage extends StatefulWidget {
  const FindServicesPage({super.key});

  @override
  State<FindServicesPage> createState() => _FindServicesPageState();
}

class _FindServicesPageState extends State<FindServicesPage> {
  String _selectedCategory = "All";
  String _searchQuery = "";

  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": Icons.grid_view},
    {"name": "Electrician", "icon": Icons.bolt},
    {"name": "Plumber", "icon": Icons.plumbing},
    {"name": "Cleaning", "icon": Icons.cleaning_services},
    {"name": "Painter", "icon": Icons.format_paint},
  ];

  // Logic to toggle Favorites in Firestore
  void _toggleFavorite(String providerEmail, Map<String, dynamic> serviceData) async {
    String? customerEmail = SessionManager.loggedInUserEmail;
    if (customerEmail == null) return;

    var favRef = FirebaseFirestore.instance
        .collection('customer_profiles')
        .doc(customerEmail)
        .collection('favorite_services')
        .doc(providerEmail);

    var doc = await favRef.get();
    if (doc.exists) {
      await favRef.delete();
    } else {
      await favRef.set({
        ...serviceData,
        'favoritedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Find Services", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by name or area...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),

          // 2. CATEGORIES
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCategory == _categories[index]['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = _categories[index]['name']),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_categories[index]['icon'], color: isSelected ? Colors.white : Colors.teal),
                        Text(_categories[index]['name'], style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.teal)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. REAL-TIME LIST FROM FIRESTORE
          Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('services').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) return const Center(child: Text("Error loading data"));
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.teal));

      // --- SMART MULTI-WORD SEARCH ---
List<QueryDocumentSnapshot> docs = snapshot.data!.docs.where((doc) {
  try {
    var data = doc.data() as Map<String, dynamic>;
    
    // 1. Get database values
    String name = (data['name'] ?? "").toString().toLowerCase();
    String area = (data['area'] ?? "").toString().toLowerCase();
    
    // 2. Split your search into separate words (e.g., "Carpenter Baldia" -> ["carpenter", "baldia"])
    List<String> keywords = _searchQuery.trim().toLowerCase().split(" ");

    // 3. Category Filter (The Boxes)
    bool matchesCategory = _selectedCategory == "All" || name == _selectedCategory.toLowerCase();

    // 4. Smart Search Filter 
    // This checks if EVERY word you typed exists in either the 'name' or 'area'
    bool matchesSearch = keywords.every((word) => 
      name.contains(word) || area.contains(word)
    );

    return matchesCategory && matchesSearch;
  } catch (e) {
    return false; // Skip any broken data to prevent red screen
  }
}).toList();

      if (docs.isEmpty) return const Center(child: Text("No services found"));

      return ListView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) {
          var data = docs[index].data() as Map<String, dynamic>;
          
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(data['name']?.toString() ?? "Service"),
              subtitle: Text("${data['area'] ?? ''} - ${data['city'] ?? ''}"),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () async {
                  String phone = data['phone']?.toString() ?? "";
                  if (phone.isNotEmpty) {
                    final Uri url = Uri.parse("tel:$phone");
                    await launchUrl(url);
                  }
                },
              ),
            ),
          );
        },
      );
    },
  ),
),
        ],
      ),
    );
  }
}