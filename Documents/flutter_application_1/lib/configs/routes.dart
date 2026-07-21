import 'package:get/get.dart';

import '../views/add_patient_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/edit_patient_screen.dart';
import '../views/home.dart';
import '../views/login.dart';
import '../views/patient_details_screen.dart';
import '../views/patient_list_screen.dart';
import '../views/registration.dart';

class AppRoutes {
  static const String login = '/';
  static const String registration = '/registration';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String patientList = '/patient-list';
  static const String addPatient = '/add-patient';
  static const String patientDetails = '/patient-details';
  static const String editPatient = '/edit-patient';
}

final List<GetPage> routes = [
  GetPage(
    name: AppRoutes.login,
    page: () => const Login(),
  ),
  GetPage(
    name: AppRoutes.registration,
    page: () => const RegistrationScreen(),
  ),
  GetPage(
    name: AppRoutes.home,
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: AppRoutes.dashboard,
    page: () => const DashboardScreen(),
  ),
  GetPage(
    name: AppRoutes.patientList,
    page: () => const PatientListScreen(),
  ),
  GetPage(
    name: AppRoutes.addPatient,
    page: () => const AddPatientScreen(),
  ),
  GetPage(
    name: AppRoutes.patientDetails,
    page: () => const PatientDetailsScreen(),
  ),
  GetPage(
    name: AppRoutes.editPatient,
    page: () => const EditPatientScreen(),
  ),
];