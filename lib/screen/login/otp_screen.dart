import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:medicare/common/color_extension.dart';
import 'package:medicare/screen/login/verified_screen.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber; // Receive mobile number from previous screen

  const OTPScreen({super.key, required this.mobileNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String? errorMessage;

  Future<void> verifyOtp(String otp) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.158.150:8585/api/login/otp-verify'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobileno": widget.mobileNumber,
          "otp": otp,
        }),
      );


      if (response.statusCode == 200) {
        print("Authenticated");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerifiedScreen()),
        );
      } else {
        setState(() {
          errorMessage = "Invalid OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred. Please check your connection.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.3),
              Image.asset(
                "assets/img/color_logo.png",
                width: MediaQuery.of(context).size.width * 0.33,
              ),
              const SizedBox(height: 20),
              Text(
                "Enter Verification Code",
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Enter the 6-digit code sent to your mobile.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: TColor.placeholder,
                  focusedBorderColor: TColor.primary,
                  textStyle: const TextStyle(
                    color: Color(0xff43C73D),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  showFieldAsBox: false,
                  onSubmit: (otp) {
                    verifyOtp(otp); // Verify OTP on submit
                  },
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: InkWell(
                  onTap: () {
                    // Example call: Pass a dummy OTP for testing purposes.
                    verifyOtp("123456");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
