import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'configs/routes.dart';
import 'controllers/patient_controllers.dart';

void main() {
  Get.put(PatientController());
  runApp(const GradingApp());
}

class GradingApp extends StatelessWidget {
  const GradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Patient Records',
      initialRoute: AppRoutes.login,
      getPages: routes,
    );
  }
}