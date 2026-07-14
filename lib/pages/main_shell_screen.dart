import 'package:flutter/material.dart';
import 'package:influx/widgets/bottom_nav/bottom_navbar.dart';
import '../widgets/expenses/expenses_page.dart';
import 'home_page.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    Center(child: Text('Spese', style: TextStyle(color: Colors.white, fontSize: 14))),
    ExpensesPage(),
    Center(child: Text('Gruppo', style: TextStyle(color: Colors.white, fontSize: 14))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: MainBottomNav(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}