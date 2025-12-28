import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'auth_state.dart'; // Ensure this path is correct

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  final _formKey = GlobalKey<FormState>(); // Added for validation
  bool _isEditing = true; 
  bool _isLoading = true; // For initial data fetch

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  var phoneMask = MaskTextInputFormatter(
    mask: '####-#######', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _fetchCustomerData(); // Fetch existing info on load
  }

  // --- LOGIC: FETCH DATA FROM FIRESTORE ---
  Future<void> _fetchCustomerData() async {
    String? userEmail = SessionManager.loggedInUserEmail;
    if (userEmail == null) return;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('customer_profiles')
          .doc(userEmail)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? "";
          _phoneController.text = data['phone'] ?? "";
          _emailController.text = data['email'] ?? userEmail;
          _addressController.text = data['address'] ?? "";
          _isEditing = false; // Directly show profile if data exists
          _isLoading = false;
        });
      } else {
        _emailController.text = userEmail; // Pre-fill email even for new users
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching customer profile: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- LOGIC: SAVE OR UPDATE DATA ---
  Future<void> _saveCustomerProfile() async {
    // Validate all fields
    if (_formKey.currentState!.validate()) {
      String? userEmail = SessionManager.loggedInUserEmail;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.teal)),
      );

      try {
        await FirebaseFirestore.instance
            .collection('customer_profiles')
            .doc(userEmail)
            .set({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'address': _addressController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        setState(() => _isEditing = false); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully!"), backgroundColor: Colors.teal),
        );
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

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
        child: Form( // Added Form wrapper
          key: _formKey,
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
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        _buildTextField(_nameController, "Full Name", Icons.person_outline),
        _buildTextField(
          _phoneController, 
          "Phone No", 
          Icons.phone_outlined, 
          formatter: phoneMask,
          inputType: TextInputType.number,
        ),
        _buildTextField(
          _emailController, 
          "Email", 
          Icons.email_outlined, 
          inputType: TextInputType.emailAddress,
          isReadOnly: true, // Email set to ReadOnly
        ),
        _buildTextField(_addressController, "Address", Icons.home_outlined, maxLines: 2),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _saveCustomerProfile, 
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

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {int maxLines = 1, MaskTextInputFormatter? formatter, TextInputType inputType = TextInputType.text, bool isReadOnly = false}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField( // Switched to TextFormField for validation
        controller: controller,
        readOnly: isReadOnly,
        maxLines: maxLines,
        keyboardType: inputType,
        inputFormatters: formatter != null ? [formatter] : [],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: formatter?.getMask(),
          prefixIcon: Icon(icon, color: Colors.teal),
          filled: isReadOnly,
          fillColor: isReadOnly ? Colors.grey[200] : null,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value.isEmpty ? "Not Provided" : value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}