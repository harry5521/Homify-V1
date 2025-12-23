import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // 1. Import the package

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  bool _isEditing = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // 2. Define the Masks for CNIC and Phone
  var cnicMask = MaskTextInputFormatter(
    mask: '#####-#######-#', 
    filter: { "#": RegExp(r'[0-9]') }
  );
  
  var phoneMask = MaskTextInputFormatter(
    mask: '####-#######', 
    filter: { "#": RegExp(r'[0-9]') }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Provider Profile", style: TextStyle(color: Colors.white)),
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

  Widget _buildEditForm() {
    return Column(
      children: [
        _buildTextField(_nameController, "Full Name", Icons.person_outline),
        
        // 3. Apply CNIC Mask
        _buildTextField(
          _cnicController, 
          "CNIC No", 
          Icons.badge_outlined, 
          formatter: cnicMask,
          inputType: TextInputType.number
        ),
        
        // 4. Apply Phone Mask
        _buildTextField(
          _phoneController, 
          "Phone No", 
          Icons.phone_outlined, 
          formatter: phoneMask,
          inputType: TextInputType.number
        ),
        
        _buildTextField(_emailController, "Email", Icons.email_outlined, inputType: TextInputType.emailAddress),
        _buildTextField(_addressController, "Address", Icons.home_outlined, maxLines: 2),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() => _isEditing = false);
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

  Widget _buildProfileView() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.person, "Name", _nameController.text),
            _buildInfoRow(Icons.badge, "CNIC", _cnicController.text),
            _buildInfoRow(Icons.phone, "Phone", _phoneController.text),
            _buildInfoRow(Icons.email, "Email", _emailController.text),
            _buildInfoRow(Icons.map, "Address", _addressController.text),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, color: Colors.teal),
              label: const Text("Update Information", style: TextStyle(color: Colors.teal)),
            )
          ],
        ),
      ),
    );
  }

  // 5. Helper updated to accept optional formatter and keyboard type
  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {int maxLines = 1, MaskTextInputFormatter? formatter, TextInputType inputType = TextInputType.text}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: inputType,
        inputFormatters: formatter != null ? [formatter] : [],
        decoration: InputDecoration(
          labelText: label,
          hintText: formatter?.getMask(), // Shows the pattern as a hint
          prefixIcon: Icon(icon, color: Colors.teal),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2)),
        ),
      ),
    );
  }

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