import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_state.dart'; // To get the logged-in provider's email

class AddServicePage extends StatefulWidget {
  final Map<String, dynamic>? existingService;
  final String? docId; // Added to handle updates if needed later
  final bool isReadOnly;

  const AddServicePage({super.key, this.existingService, this.docId, this.isReadOnly = false});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>(); // For Validation
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  late TextEditingController _cityController;

  late bool _editMode;

  @override
  void initState() {
    super.initState();
    _editMode = widget.existingService == null ? true : !widget.isReadOnly;

    _nameController = TextEditingController(text: widget.existingService?['name'] ?? '');
    _addressController = TextEditingController(text: widget.existingService?['address'] ?? '');
    _areaController = TextEditingController(text: widget.existingService?['area'] ?? '');
    _cityController = TextEditingController(text: widget.existingService?['city'] ?? '');
  }

  // --- NEW: SAVE TO FIRESTORE LOGIC ---
  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      // Show Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.teal)),
      );

      try {
        String? providerEmail = SessionManager.loggedInUserEmail;

        Map<String, dynamic> serviceData = {
          "name": _nameController.text.trim(),
          "address": _addressController.text.trim(),
          "area": _areaController.text.trim(),
          "city": _cityController.text.trim(),
          "providerEmail": providerEmail, // Link service to this provider
          "createdAt": FieldValue.serverTimestamp(),
        };

        if (widget.docId == null) {
          // CREATE NEW SERVICE
          await FirebaseFirestore.instance.collection('services').add(serviceData);
        } else {
          // UPDATE EXISTING SERVICE
          await FirebaseFirestore.instance.collection('services').doc(widget.docId).update(serviceData);
        }

        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Service Saved Successfully!"), backgroundColor: Colors.teal),
        );

        Navigator.pop(context); // Go back to the dashboard
      } catch (e) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editMode ? "Add Service Details" : "Service Details", 
          style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form( // Wrapped in Form for validation
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _editMode ? "Service Information" : "Modify Information",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 20),
                
                _buildTextField(_nameController, "Service Name", "e.g., Electrician", Icons.work),
                const SizedBox(height: 15),
                _buildTextField(_addressController, "Shop Address", "Street/Building", Icons.location_on),
                const SizedBox(height: 15),
                _buildTextField(_areaController, "Area", "e.g., Gulshan-e-Iqbal", Icons.map),
                const SizedBox(height: 15),
                _buildTextField(_cityController, "City", "e.g., Karachi", Icons.location_city),

                const SizedBox(height: 30),

                if (!_editMode)
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _editMode = true),
                    icon: const Icon(Icons.edit),
                    label: const Text("Update Details", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _saveService, // Trigger validation and save
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(widget.existingService == null ? "Save Service" : "Save Changes", 
                      style: const TextStyle(fontSize: 18)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon) {
    return TextFormField( // Changed to TextFormField for validator
      controller: controller,
      readOnly: !_editMode,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: !_editMode,
        fillColor: Colors.grey.withOpacity(0.1),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2)),
      ),
    );
  }
}