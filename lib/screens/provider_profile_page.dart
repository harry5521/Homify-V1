import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added Firestore
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'auth_state.dart'; // Import your SessionManager to get the logged-in email

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  bool _isEditing = true;
  bool _isLoading = true; // Added to show a loader while fetching data

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  var cnicMask = MaskTextInputFormatter(
    mask: '#####-#######-#', 
    filter: { "#": RegExp(r'[0-9]') }
  );
  
  var phoneMask = MaskTextInputFormatter(
    mask: '####-#######', 
    filter: { "#": RegExp(r'[0-9]') }
  );

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch data as soon as the page opens
  }

  // --- NEW: FETCH DATA FROM DB ---
  Future<void> _fetchProfileData() async {
    String? userEmail = SessionManager.loggedInUserEmail; // Get email from your session
    
    if (userEmail == null) return;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('provider_profiles')
          .doc(userEmail)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? "";
          _cnicController.text = data['cnic'] ?? "";
          _phoneController.text = data['phone'] ?? "";
          _emailController.text = data['email'] ?? userEmail;
          _addressController.text = data['address'] ?? "";
          _isEditing = false; // Directly show details if data exists
          _isLoading = false;
        });
      } else {
        // If no profile exists, stay in editing mode but set the email automatically
        _emailController.text = userEmail;
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching profile: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- NEW: SAVE OR UPDATE DATA IN DB ---
  Future<void> _saveProfileToDB() async {
    String? userEmail = SessionManager.loggedInUserEmail;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.teal)),
    );

    try {
      // .set with SetOptions(merge: true) handles both Initial Create AND Update
      await FirebaseFirestore.instance
          .collection('provider_profiles')
          .doc(userEmail)
          .set({
        'name': _nameController.text.trim(),
        'cnic': _cnicController.text.trim(),
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
        SnackBar(content: Text("Error saving data: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

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
        _buildTextField(_cnicController, "CNIC No", Icons.badge_outlined, formatter: cnicMask, inputType: TextInputType.number),
        _buildTextField(_phoneController, "Phone No", Icons.phone_outlined, formatter: phoneMask, inputType: TextInputType.number),
        _buildTextField(_emailController, "Email", Icons.email_outlined, inputType: TextInputType.emailAddress, isReadOnly: true,),
        _buildTextField(_addressController, "Address", Icons.home_outlined, maxLines: 2),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _saveProfileToDB, // Call the DB save function
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

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {int maxLines = 1, MaskTextInputFormatter? formatter, TextInputType inputType = TextInputType.text, bool isReadOnly = false,}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        maxLines: maxLines,
        keyboardType: inputType,
        inputFormatters: formatter != null ? [formatter] : [],
        decoration: InputDecoration(
          labelText: label,
          // hintText: formatter?.getMask(),
          filled: isReadOnly,
          fillColor: isReadOnly ? Colors.grey[200] : null,
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
          Expanded( // Added Expanded to avoid text overflow
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