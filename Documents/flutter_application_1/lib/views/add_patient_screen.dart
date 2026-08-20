import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../configs/colors.dart';
import '../controllers/patient_controllers.dart';
import '../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() =>
      _AddPatientScreenState();
}

class _AddPatientScreenState
    extends State<AddPatientScreen> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController ageController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController illnessController =
      TextEditingController();

  final PatientController patientController =
      Get.find<PatientController>();

  String selectedGender = 'Male';
  bool isLoading = false;

  Future<void> savePatient() async {
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
        'http://localhost/hospital_api/add_patient.php',
      );

      final http.Response response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type':
              'application/x-www-form-urlencoded',
        },
        body: {
          'name': nameController.text.trim(),
          'age': ageController.text.trim(),
          'gender': selectedGender,
          'phone': phoneController.text.trim(),
          'illness': illnessController.text.trim(),
        },
      );

      final String cleanBody = response.body
          .replaceFirst('\uFEFF', '')
          .trim();

      debugPrint(
        'ADD PATIENT STATUS: ${response.statusCode}',
      );

      debugPrint(
        'ADD PATIENT BODY: $cleanBody',
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

      if (!success) {
        Get.snackbar(
          'Unable to add patient',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          duration: const Duration(seconds: 5),
        );

        return;
      }

      final dynamic patientData = result['data'];

      if (patientData is! Map) {
        throw Exception(
          'The server did not return patient data.',
        );
      }

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(
        patientData,
      );

      final Patient patient = Patient(
        id: data['id'].toString(),
        name: data['name']?.toString() ??
            nameController.text.trim(),
        age: int.tryParse(
              data['age'].toString(),
            ) ??
            int.parse(
              ageController.text.trim(),
            ),
        gender: data['gender']?.toString() ??
            selectedGender,
        phone: data['phone']?.toString() ??
            phoneController.text.trim(),
        illness: data['illness']?.toString() ??
            illnessController.text.trim(),
      );

      patientController.addPatient(patient);

      if (!mounted) {
        return;
      }

      Get.back();

      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      Get.snackbar(
        'Connection error',
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
    ageController.dispose();
    phoneController.dispose();
    illnessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Patient'),
        backgroundColor:
            AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Patient name',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.person),
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter the patient name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: ageController,
                keyboardType:
                    TextInputType.number,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Age',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.calendar_month),
                ),
                validator: (String? value) {
                  final int? age = int.tryParse(
                    value?.trim() ?? '',
                  );

                  if (age == null) {
                    return 'Enter a valid age';
                  }

                  if (age <= 0 || age > 130) {
                    return 'Enter an age between 1 and 130';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: selectedGender,
                decoration:
                    const InputDecoration(
                  labelText: 'Gender',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.people),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: isLoading
                    ? null
                    : (String? value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedGender = value;
                        });
                      },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                keyboardType:
                    TextInputType.phone,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Phone number',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.phone),
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter a phone number';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller:
                    illnessController,
                textInputAction:
                    TextInputAction.done,
                onFieldSubmitted: (_) {
                  savePatient();
                },
                decoration:
                    const InputDecoration(
                  labelText:
                      'Illness or condition',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.medical_information,
                  ),
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter the illness or condition';
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
                  onPressed:
                      isLoading ? null : savePatient,
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
                          'Save Patient',
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