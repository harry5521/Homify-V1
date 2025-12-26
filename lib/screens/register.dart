import 'package:flutter/material.dart';
import 'verification_page.dart';
import 'package:email_otp/email_otp.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to get data from fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   bool _isObscured = true;
  // Default role

  String _selectedRole = 'Customer';
  final List<String> _roles = ['Customer', 'Provider'];

// sxtv pcec tstk ftnw

void _handleRegister() async {
  if (_formKey.currentState!.validate()) {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String role = _selectedRole;

    // 2. Print to terminal for debugging
    print("--- NEW USER REGISTERED ---");
    print("Email: $email");
    print("Password: $password");
    print("Role: $role");
    print("---------------------------");

    // 3. Navigate to Login Screen
    // We pass a 'success' flag so the Login screen knows to show the alert
    Navigator.pushReplacementNamed(
      context, 
      '/login', 
      arguments: {'registered': true}
    );

    
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using SafeArea and Center to match the Login Page layout
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Matching Icon and Title Style
                    const Icon(Icons.person_add_rounded, size: 80, color: Colors.teal),
                    const SizedBox(height: 10),
                    const Text(
                      "Join Homify",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        // Regex for email format validation
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                  // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        if (value.length < 8) return 'Password must be at least 8 characters';
                        return null;
                      },
                    ),
                  
                    const SizedBox(height: 20),

                    // Role Dropdown (Styled to match)
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Register as",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment_ind_outlined),
                      ),
                      items: _roles.map((String role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Create Account", style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 25),

                    // Back to Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Goes back to Login
                          },
                          child: const Text(
                            "Login here",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}