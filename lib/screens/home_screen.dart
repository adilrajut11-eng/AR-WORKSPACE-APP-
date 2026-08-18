import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import 'symptoms_screen.dart';
import 'diagnosis_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Doctor'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, _) {
          return IndexedStack(
            index: _selectedIndex,
            children: const [
              SymptomsScreen(),
              DiagnosisScreen(),
              HistoryScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Symptoms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stethoscope),
            label: 'Diagnosis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}