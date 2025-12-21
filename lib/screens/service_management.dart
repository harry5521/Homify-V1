import 'package:flutter/material.dart';
import 'add_service_page.dart'; // Import the new page

class ServiceManagementPage extends StatefulWidget {
  const ServiceManagementPage({super.key});

  @override
  State<ServiceManagementPage> createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  final List<String> _myServices = ["Home Cleaning", "Plumbing"];

  // Logic to navigate and wait for the new service name
  void _navigateAndAddService() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddServicePage()),
    );

    // If result is received, update the list
    if (result != null && result is String) {
      setState(() {
        _myServices.add(result);
      });
    }
  }

  void _deleteService(int index) {
    setState(() {
      _myServices.removeAt(index);
    });
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
          // Header Section - Simplified to just a button and label
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
                  onPressed: _navigateAndAddService, // Calls the navigation logic
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
            child: _myServices.isEmpty
                ? const Center(child: Text("No services added yet."))
                : ListView.builder(
                    itemCount: _myServices.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.teal),
                          title: Text(_myServices[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _deleteService(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 