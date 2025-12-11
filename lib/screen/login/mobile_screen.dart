import 'dart:convert';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicare/common/color_extension.dart';
import 'package:medicare/screen/login/otp_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final FlCountryCodePicker countryCodePicker = const FlCountryCodePicker();
  late CountryCode countryCode;
  final TextEditingController mobileController = TextEditingController();
  bool isLoading = false; // Loading indicator
  String? errorMessage; // Error message display

  @override
  void initState() {
    super.initState();
    countryCode = countryCodePicker.countryCodes
        .firstWhere((element) => element.name == "India");
  }

  Future<void> sendOtp(String phoneNumber) async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Reset the error message
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.158.150:8585/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobileno": phoneNumber}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("OTP Sent");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(mobileNumber: phoneNumber),
          ),
        );
      } else {
        setState(() {
          errorMessage = "Failed to send OTP. Please try again.";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        errorMessage = "An error occurred. Check your connection.";
      });
    } finally {
      setState(() {
        isLoading = false;
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
                "Enter Mobile Number",
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "The verification code will be sent to the number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: TColor.placeholder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        final code = await countryCodePicker.showPicker(
                          context: context,
                        );
                        if (code != null) {
                          setState(() {
                            countryCode = code;
                          });
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: TColor.placeholder,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          countryCode.dialCode,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ex: 9876543210",
                          hintStyle: TextStyle(
                            color: TColor.placeholder,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: InkWell(
                  onTap: isLoading
                      ? null
                      : () {
                    final phoneNumber =
                        '${mobileController.text.trim()}';
                    if (mobileController.text.trim().isNotEmpty) {
                      sendOtp(phoneNumber);
                    } else {
                      setState(() {
                        errorMessage = "Please enter a valid number.";
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Send OTP",
                      style: TextStyle(
                        color: Colors.blue,
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
