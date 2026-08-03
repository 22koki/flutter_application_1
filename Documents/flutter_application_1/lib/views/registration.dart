import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../configs/colors.dart';
import '../configs/routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState
    extends State<RegistrationScreen> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> registerUser() async {
    final bool isValid =
        formKey.currentState?.validate() ?? false;

    if (!isValid || isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse(
        'http://localhost/hospital_api/register.php',
      );

      final http.Response response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type':
              'application/x-www-form-urlencoded',
        },
        body: {
          'full_name': nameController.text.trim(),
          'username':
              usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password':
              passwordController.text.trim(),
          'role': 'staff',
        },
      );

      final String cleanBody = response.body
          .replaceFirst('\uFEFF', '')
          .trim();

      debugPrint(
        'REGISTER STATUS: ${response.statusCode}',
      );
      debugPrint(
        'REGISTER BODY: $cleanBody',
      );

      if (cleanBody.isEmpty) {
        throw Exception(
          'The server returned an empty response.',
        );
      }

      dynamic decodedResponse;

      try {
        decodedResponse = jsonDecode(cleanBody);
      } on FormatException {
        throw Exception(
          'The server returned invalid data: $cleanBody',
        );
      }

      if (decodedResponse is! Map) {
        throw Exception(
          'Unexpected response from the server.',
        );
      }

      final Map<String, dynamic> result =
          Map<String, dynamic>.from(
        decodedResponse,
      );

      final bool success =
          result['success'] == 1 ||
          result['success'] == true;

      final String message =
          result['message']?.toString() ??
              'No message returned';

      if (success) {
        Get.snackbar(
          'Registration successful',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          duration: const Duration(seconds: 3),
        );

        nameController.clear();
        usernameController.clear();
        emailController.clear();
        passwordController.clear();

        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Registration failed',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (error) {
      Get.snackbar(
        'Registration error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        duration: const Duration(seconds: 6),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor:
            AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Icon(
                Icons.local_hospital,
                size: 80,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 15),
              const Text(
                'Hospital Management System',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: nameController,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon:
                      Icon(Icons.person),
                  border:
                      OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your full name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller:
                    usernameController,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Username',
                  prefixIcon:
                      Icon(Icons.account_circle),
                  border:
                      OutlineInputBorder(),
                ),
                validator: (String? value) {
                  final String username =
                      value?.trim() ?? '';

                  if (username.isEmpty) {
                    return 'Enter a username';
                  }

                  if (username.length < 3) {
                    return 'Username must have at least 3 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon:
                      Icon(Icons.email),
                  border:
                      OutlineInputBorder(),
                ),
                validator: (String? value) {
                  final String email =
                      value?.trim() ?? '';

                  if (email.isEmpty) {
                    return 'Enter your email address';
                  }

                  if (!GetUtils.isEmail(email)) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller:
                    passwordController,
                obscureText: hidePassword,
                textInputAction:
                    TextInputAction.done,
                onFieldSubmitted: (_) {
                  registerUser();
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon:
                      const Icon(Icons.lock),
                  border:
                      const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword =
                            !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Enter your password';
                  }

                  if (value.length < 4) {
                    return 'Password must have at least 4 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor,
                    foregroundColor:
                        Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : registerUser,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Get.offNamed(
                          AppRoutes.login,
                        );
                      },
                child: const Text(
                  'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}