import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tool_provider.dart';
import 'osint_screen.dart';
import 'tools_screen.dart';
import 'radio_screen.dart';
import 'crypto_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> screens = const [
    OSINTScreen(),
    ToolsScreen(),
    RadioScreen(),
    CryptoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔓 OSINT & Tools Suite'),
        elevation: 0,
        centerTitle: true,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'OSINT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waves),
            label: 'Radio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Crypto',
          ),
        ],
      ),
    );
  }
}