import 'package:flutter/material.dart';

class ServiceManagementPage extends StatefulWidget {
  const ServiceManagementPage({super.key});

  @override
  State<ServiceManagementPage> createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  final List<String> _myServices = ["Home Cleaning", "Plumbing"];
  final TextEditingController _serviceController = TextEditingController();

  void _addService() {
    if (_serviceController.text.isNotEmpty) {
      setState(() {
        _myServices.add(_serviceController.text);
        _serviceController.clear();
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
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.teal.withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _serviceController,
                    decoration: const InputDecoration(
                      hintText: "Enter service name (e.g. Painting)",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // FIXED SECTION BELOW
                IconButton.filled(
                  onPressed: _addService,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // List of Services
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