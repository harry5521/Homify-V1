import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added Firestore
import 'add_service_page.dart';
import 'auth_state.dart'; // To get the logged-in email

class ServiceManagementPage extends StatefulWidget {
  const ServiceManagementPage({super.key});

  @override
  State<ServiceManagementPage> createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  
  // 1. DELETE LOGIC FROM FIRESTORE
  void _deleteService(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('services').doc(docId).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service deleted successfully"), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting: $e")),
      );
    }
  }

  // 2. UPDATED NAVIGATION (Passes the docId for editing)
  void _viewServiceDetails(Map<String, dynamic> data, String docId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddServicePage(
          existingService: data,
          docId: docId, // Pass the ID so the AddServicePage knows to UPDATE not ADD
          isReadOnly: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Services", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.teal.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Active Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                IconButton.filled(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddServicePage()),
                  ),
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            // 3. STREAMBUILDER: Automatically fetches data for the logged-in provider
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('services')
                  .where('providerEmail', isEqualTo: SessionManager.loggedInUserEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.teal));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No services added yet."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    Map<String, dynamic> service = doc.data() as Map<String, dynamic>;
                    String docId = doc.id; // The auto-generated ID from Firestore

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListTile(
                        onTap: () => _viewServiceDetails(service, docId),
                        leading: const Icon(Icons.handyman, color: Colors.teal),
                        title: Text(service['name'] ?? 'Unknown Service', 
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${service['area']}, ${service['city']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            // Show a quick confirmation before deleting
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Service"),
                                content: const Text("Are you sure you want to remove this service?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteService(docId);
                                    }, 
                                    child: const Text("Delete", style: TextStyle(color: Colors.red))
                                  ),
                                ],
                              ),
                            );
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