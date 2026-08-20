import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../configs/colors.dart';
import '../configs/routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> registerUser() async {
    final bool isValid = formKey.currentState?.validate() ?? false;

    if (!isValid || isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse('http://localhost/hospital_api/register.php');

      final http.Response response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'full_name': nameController.text.trim(),
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'role': 'staff',
        },
      );

      final String cleanBody = response.body.replaceFirst('\uFEFF', '').trim();

      if (cleanBody.isEmpty) {
        throw Exception('The server returned an empty response.');
      }

      dynamic decodedResponse;

      try {
        decodedResponse = jsonDecode(cleanBody);
      } on FormatException {
        throw Exception('The server returned invalid data: $cleanBody');
      }

      if (decodedResponse is! Map) {
        throw Exception('Unexpected response from the server.');
      }

      final Map<String, dynamic> result = Map<String, dynamic>.from(
        decodedResponse,
      );

      final bool success = result['success'] == 1 || result['success'] == true;

      final String message =
          result['message']?.toString() ?? 'No message returned';

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
      backgroundColor: const Color(0xFFF2F7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth >= 850;

            return isDesktop ? _desktopLayout() : _mobileLayout();
          },
        ),
      ),
    );
  }

  Widget _desktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: SizedBox(
            height: 700,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 35,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Expanded(flex: 5, child: _buildBrandPanel()),
                  Expanded(flex: 6, child: _buildFormSection()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMobileHero(),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: _buildFormSection(mobile: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      padding: const EdgeInsets.all(46),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            Color(0xFF0B86B8),
            Color(0xFF075A82),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _decorativeCircle(size: 230, opacity: 0.08),
          ),
          Positioned(
            bottom: -110,
            left: -95,
            child: _decorativeCircle(size: 280, opacity: 0.07),
          ),
          Positioned(
            bottom: 85,
            right: 25,
            child: _decorativeCircle(size: 90, opacity: 0.06),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _hospitalLogo(),
              const SizedBox(height: 82),
              const Text(
                'Smarter patient\nmanagement starts here.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  height: 1.14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'A secure and modern workspace for managing '
                'patient information and hospital records.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 35),
              _featureItem(
                Icons.shield_outlined,
                'Secure records',
                'Keep patient information organised',
              ),
              const SizedBox(height: 18),
              _featureItem(
                Icons.bolt_rounded,
                'Fast access',
                'Reach important records quickly',
              ),
              const SizedBox(height: 18),
              _featureItem(
                Icons.dashboard_customize_outlined,
                'Simple management',
                'Built for an efficient hospital workflow',
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  Container(
                    height: 8,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 7),
                  _smallDot(),
                  const SizedBox(width: 7),
                  _smallDot(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hospitalLogo() {
    return Row(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.local_hospital_rounded,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Hospital Management\nSystem',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.68),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 65),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            Color(0xFF0B86B8),
            Color(0xFF075A82),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Column(
        children: [
          _hospitalLogo(),
          const SizedBox(height: 30),
          const Text(
            'Create your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start managing patient records securely',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.76),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({bool mobile = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 24 : 54,
        vertical: mobile ? 30 : 42,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!mobile) ...[
              _registrationBadge(),
              const SizedBox(height: 18),
              const Text(
                'Create your account',
                style: TextStyle(
                  color: Color(0xFF172B3A),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Register as hospital staff to continue.',
                style: TextStyle(color: Color(0xFF788896), fontSize: 14),
              ),
              const SizedBox(height: 26),
            ],
            _sectionLabel('PERSONAL INFORMATION'),
            const SizedBox(height: 11),
            _buildTextField(
              controller: nameController,
              label: 'Full name',
              hint: 'Enter your full name',
              icon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter your full name';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: usernameController,
              label: 'Username',
              hint: 'Choose a username',
              icon: Icons.alternate_email_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final String username = value?.trim() ?? '';

                if (username.isEmpty) {
                  return 'Enter a username';
                }

                if (username.length < 3) {
                  return 'Username must have at least 3 characters';
                }

                return null;
              },
            ),
            const SizedBox(height: 21),
            _sectionLabel('ACCOUNT SECURITY'),
            const SizedBox(height: 11),
            _buildTextField(
              controller: emailController,
              label: 'Email address',
              hint: 'name@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final String email = value?.trim() ?? '';

                if (email.isEmpty) {
                  return 'Enter your email address';
                }

                if (!GetUtils.isEmail(email)) {
                  return 'Enter a valid email address';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: hidePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                registerUser();
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF78909C),
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
            _registerButton(),
            const SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(color: Color(0xFF7B8A97), fontSize: 13),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Get.offNamed(AppRoutes.login);
                        },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF263845),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAB6BF), fontSize: 13),
        labelStyle: const TextStyle(color: Color(0xFF71828F)),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryColor),
          ),
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE4ECF1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE4ECF1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.7,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isLoading
            ? null
            : const LinearGradient(
                colors: [AppColors.primaryColor, Color(0xFF087BA5)],
              ),
        color: isLoading ? Colors.grey.shade300 : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isLoading
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.24),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : registerUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _registrationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_add_alt_1_rounded,
            color: AppColors.primaryColor,
            size: 17,
          ),
          SizedBox(width: 7),
          Text(
            'STAFF REGISTRATION',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 11,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF7C8C98),
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _decorativeCircle({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _smallDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        shape: BoxShape.circle,
      ),
    );
  }
}
