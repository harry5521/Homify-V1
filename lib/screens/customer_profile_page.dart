import 'package:flutter/material.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  // Logic to toggle between View and Edit mode
  bool _isEditing = true; 

  // Controllers for input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.visibility : Icons.edit),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Header Icon
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            _isEditing ? _buildEditForm() : _buildProfileView(),
          ],
        ),
      ),
    );
  }

  // UI for Inserting/Updating Data
  Widget _buildEditForm() {
    return Column(
      children: [
        _buildTextField(_nameController, "Full Name", Icons.person_outline),
        _buildTextField(_phoneController, "Phone No", Icons.phone_outlined),
        _buildTextField(_emailController, "Email", Icons.email_outlined),
        _buildTextField(_addressController, "Address", Icons.home_outlined, maxLines: 2),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() => _isEditing = false); // Save and switch to view
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile Saved Successfully!"), backgroundColor: Colors.teal),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Save Details", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }

  // UI for Displaying Saved Data
  Widget _buildProfileView() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.person, "Name", _nameController.text),
            _buildInfoRow(Icons.phone, "Phone", _phoneController.text),
            _buildInfoRow(Icons.email, "Email", _emailController.text),
            _buildInfoRow(Icons.map, "Address", _addressController.text),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, color: Colors.teal),
              label: const Text("Update Information", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  // Helper widget for TextFields
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2)),
        ),
      ),
    );
  }

  // Helper widget for View Rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value.isEmpty ? "Not Provided" : value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}