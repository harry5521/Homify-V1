import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

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
    String otp = _controllers.map((controller) => controller.text).join();
    
    if (otp.length == 6) {
      if (otp == "123456") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification Successful!"), backgroundColor: Colors.teal),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Code. Please try again."), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full 6-digit code.")),
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

      body: SingleChildScrollView( // Added scroll safety
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Top spacing
              const Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                "Enter Verification Code",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We have sent a 6-digit code to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              
              // FITTEDBOX prevents the "Right Overflow" error on small screens
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Padding(
                      // Reduced padding from 8.0 to 4.0 to save horizontal space
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
            ],
          ),
        ),
      ),
    );
  }

        Widget _buildOtpBox(int index) {
            return SizedBox(
            // Reduced width from 45 to 40 for better mobile fitting
            width: 40,
            child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                // Slightly smaller font for better fit
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.zero, // Centers text vertically
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.circular(8),
                ),
                ),
                onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                    _focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                }
                },
            ),
            );
        }
        }