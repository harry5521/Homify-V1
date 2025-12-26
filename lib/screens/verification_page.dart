import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

class VerificationPage extends StatefulWidget {
  // 1. RECEIVE EMAIL FROM REGISTER PAGE
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }


void _verifyCode() {
  // Join the characters from the 6 controllers
  String otp = _controllers.map((controller) => controller.text).join();
  
  if (otp.length == 6) {
    // 1. VERIFY WITH PACKAGE
    bool isVerified = EmailOTP.verifyOTP(otp: otp);

    if (isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification Successful!"), backgroundColor: Colors.teal),
      );
      // Proceed to login or dashboard
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Code. Please check your email again."), backgroundColor: Colors.red),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter all 6 digits.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                "Enter Verification Code",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // 2. DYNAMIC EMAIL DISPLAY
              Text(
                "We have sent a 6-digit code to:\n${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildOtpBox(index),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("VERIFY", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add Resend logic here later
                }, 
                child: const Text("Resend Code", style: TextStyle(color: Colors.teal))
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45, // Slightly wider for better touch targets
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 2.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus(); // Close keyboard on last digit
              _verifyCode(); // Auto-verify when last digit is entered
            }
          } else {
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }
}