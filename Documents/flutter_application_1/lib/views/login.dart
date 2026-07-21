import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/routes.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  void loginUser() {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing information',
        'Enter your username and password',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.offAllNamed(AppRoutes.home);
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
        title: const Text('Hospital Management System'),
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
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Password',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
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
              MaterialButton(
                onPressed: loginUser,
                color: AppColors.primaryColor,
                minWidth: 220,
                height: 45,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.registration);
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
                        snackPosition: SnackPosition.BOTTOM,
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