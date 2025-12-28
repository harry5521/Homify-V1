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
    {"name": "Favorites", "icon": Icons.star, "color": Colors.orange},
    {"name": "Electrician", "icon": Icons.bolt},
    {"name": "Plumber", "icon": Icons.plumbing},
    {"name": "Cleaning", "icon": Icons.cleaning_services},
    {"name": "Painter", "icon": Icons.format_paint},
  ];

  // Modified to use unique docId to prevent the "multiple star" bug
  void _toggleFavorite(String docId, Map<String, dynamic> serviceData) async {
    String? customerEmail = SessionManager.loggedInUserEmail;
    if (customerEmail == null) return;

    var favRef = FirebaseFirestore.instance
        .collection('customer_profiles')
        .doc(customerEmail)
        .collection('favorite_services')
        .doc(docId); // Unique ID ensures only this specific row is toggled

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
    String? currentCustomer = SessionManager.loggedInUserEmail;

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
                    width: 85,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _categories[index]['icon'], 
                          color: isSelected ? Colors.white : (_categories[index]['color'] ?? Colors.teal)
                        ),
                        Text(
                          _categories[index]['name'], 
                          style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.teal)
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. REAL-TIME LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _selectedCategory == "Favorites"
                  ? FirebaseFirestore.instance
                      .collection('customer_profiles')
                      .doc(currentCustomer)
                      .collection('favorite_services')
                      .snapshots()
                  : FirebaseFirestore.instance.collection('services').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Error loading data"));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.teal));

                var docs = snapshot.data!.docs.where((doc) {
                  try {
                    var data = doc.data() as Map<String, dynamic>;
                    String name = (data['name'] ?? "").toString().toLowerCase();
                    String area = (data['area'] ?? "").toString().toLowerCase();
                    List<String> keywords = _searchQuery.trim().split(" ");

                    bool matchesCategory = _selectedCategory == "All" || 
                                         _selectedCategory == "Favorites" || 
                                         name == _selectedCategory.toLowerCase();

                    bool matchesSearch = keywords.every((word) => 
                      name.contains(word) || area.contains(word)
                    );

                    return matchesCategory && matchesSearch;
                  } catch (e) { return false; }
                }).toList();

                if (docs.isEmpty) return const Center(child: Text("No records found"));

                return ListView.builder(
  itemCount: docs.length,
  itemBuilder: (context, index) {
    String docId = docs[index].id; 
    var data = docs[index].data() as Map<String, dynamic>;
    String providerEmail = data['providerEmail'] ?? ""; // Email used to link to profile

    return Card(
      key: ValueKey(docId),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(data['name']?.toString() ?? "Service"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${data['area'] ?? ''} - ${data['city'] ?? ''}"),
            const SizedBox(height: 4),
            // --- NEW: FETCH PROVIDER NAME LOGIC ---
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('provider_profiles')
                  .doc(providerEmail)
                  .get(),
              builder: (context, providerSnap) {
                if (providerSnap.connectionState == ConnectionState.waiting) {
                  return const Text("...", style: TextStyle(fontSize: 12));
                }
                
                String providerName = "--"; // Default if name is empty
                if (providerSnap.hasData && providerSnap.data!.exists) {
                  var pData = providerSnap.data!.data() as Map<String, dynamic>;
                  String fetchedName = pData['name']?.toString() ?? "";
                  if (fetchedName.trim().isNotEmpty) {
                    providerName = fetchedName;
                  }
                }

                return Text(
                  "Provider: $providerName",
                  style: const TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.teal
                  ),
                );
              },
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // STAR BUTTON (Unchanged)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customer_profiles')
                  .doc(currentCustomer)
                  .collection('favorite_services')
                  .doc(docId)
                  .snapshots(),
              builder: (context, favSnap) {
                bool isFav = favSnap.hasData && favSnap.data!.exists;
                return IconButton(
                  icon: Icon(isFav ? Icons.star : Icons.star_border, 
                             color: isFav ? Colors.orange : Colors.grey),
                  onPressed: () => _toggleFavorite(docId, data),
                );
              },
            ),
            // CALL BUTTON (Unchanged)
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () async {
                if (providerEmail.isNotEmpty) {
                  var providerDoc = await FirebaseFirestore.instance
                      .collection('provider_profiles') 
                      .doc(providerEmail)
                      .get();

                  if (providerDoc.exists) {
                    String phone = providerDoc.data()?['phone']?.toString() ?? "";
                    if (phone.isNotEmpty) {
                      final Uri url = Uri(scheme: 'tel', path: phone);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Could not open dialer.")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("This provider hasn't added a phone number.")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Provider profile not found.")),
                    );
                  }
                }
              },
            ),
          ],
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