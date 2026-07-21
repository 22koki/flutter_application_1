import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  void registerUser() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        'Registration successful',
        'Your account has been created',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: AppColors.primaryColor,
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
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your full name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your email address';
                  }

                  if (!value.contains('@')) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: registerUser,
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.offNamed(AppRoutes.login);
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