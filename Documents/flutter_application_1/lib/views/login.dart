


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final GetStorage store = GetStorage();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    usernameController.text =
        store.read<String>('username') ?? '';
  }

  Future<void> loginUser() async {
    final String username =
        usernameController.text.trim();

    final String password =
        passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Enter your username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse(
        'http://localhost/hospital_api/login.php',
      );

      final http.Response response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server returned status ${response.statusCode}',
        );
      }

      final dynamic decodedResponse =
          jsonDecode(response.body);

      if (decodedResponse is! Map<String, dynamic>) {
        throw Exception('Invalid server response');
      }

      final Map<String, dynamic> result =
          decodedResponse;

      if (result['success'] == 1 ||
          result['success'] == true) {
        await store.write('username', username);

        final dynamic userData = result['data'];

        if (userData is List && userData.isNotEmpty) {
          await store.write('user', userData.first);
        }

        Get.snackbar(
          'Success',
          result['message']?.toString() ??
              'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
        );

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Login failed',
          result['message']?.toString() ??
              'Invalid username or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } on FormatException {
      Get.snackbar(
        'Invalid response',
        'The server did not return valid JSON. Check login.php and connect.php.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } catch (error) {
      Get.snackbar(
        'Connection error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        duration: const Duration(seconds: 5),
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
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Hospital Management System',
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 180,
                width: 300,
                fit: BoxFit.contain,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return const Icon(
                    Icons.local_hospital,
                    size: 130,
                    color: AppColors.primaryColor,
                  );
                },
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              TextField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Enter username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!isLoading) {
                    loginUser();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: 220,
                height: 45,
                child: MaterialButton(
                  onPressed:
                      isLoading ? null : loginUser,
                  color: AppColors.primaryColor,
                  disabledColor: Colors.grey,
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
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.registration,
                      );
                    },
                    child: const Text(
                      'Not Registered? Sign Up',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        'Reset Password',
                        'Password reset is not available yet',
                        snackPosition:
                            SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text(
                      'Forgot Password? Reset',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}