import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../configs/colors.dart';
import 'add_patient_screen.dart';
import 'dashboard_screen.dart';
import 'patient_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    PatientListScreen(),
    AddPatientScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: AppColors.backgroundColor,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryColor,
        items: const [
          Icon(
            Icons.dashboard,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.people,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_add,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}