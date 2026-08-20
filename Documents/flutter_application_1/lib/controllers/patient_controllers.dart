import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/patient.dart';

class PatientController extends GetxController {
  final RxList<Patient> patients = <Patient>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Load ALL patients from MySQL when controller starts.
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Uri url = Uri.parse(
        'http://localhost/hospital_api/get_patients.php',
      );

      final http.Response response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'FETCH STATUS: ${response.statusCode}',
      );

      debugPrint(
        'FETCH BODY: ${response.body}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      final String body = response.body
          .replaceFirst('\uFEFF', '')
          .trim();

      if (body.isEmpty) {
        throw Exception(
          'Server returned an empty response',
        );
      }

      final dynamic decoded = jsonDecode(body);

      if (decoded is! Map) {
        throw Exception(
          'Invalid response format',
        );
      }

      final Map<String, dynamic> result =
          Map<String, dynamic>.from(decoded);

      final bool success =
          result['success'] == 1 ||
          result['success'] == true ||
          result['success'].toString() == '1';

      if (!success) {
        throw Exception(
          result['message']?.toString() ??
              'Unable to fetch patients',
        );
      }

      final dynamic rawData = result['data'];

      if (rawData is! List) {
        throw Exception(
          'Patient data was not returned as a list',
        );
      }

      final List<Patient> databasePatients =
          rawData.map<Patient>((item) {
        return Patient.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();

      // IMPORTANT:
      // Replace the local list with everything from MySQL.
      patients.assignAll(databasePatients);

      debugPrint(
        'DATABASE PATIENT COUNT: ${patients.length}',
      );
    } catch (error) {
      errorMessage.value = error.toString();

      debugPrint(
        'FETCH PATIENT ERROR: $error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }

  void addPatient(Patient patient) {
    patients.add(patient);
  }

  void updatePatient(
    int index,
    Patient patient,
  ) {
    if (index >= 0 &&
        index < patients.length) {
      patients[index] = patient;
      patients.refresh();
    }
  }

  void deletePatient(int index) {
    if (index >= 0 &&
        index < patients.length) {
      patients.removeAt(index);
    }
  }
}