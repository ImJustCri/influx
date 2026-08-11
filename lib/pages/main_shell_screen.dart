import 'package:flutter/material.dart';
import 'package:influx/widgets/bottom_nav/bottom_navbar.dart';
import 'expenses/expenses_page.dart';
import 'groups/groups_page.dart';
import 'home_page.dart';
// Import your GlobalBackground or AppGradients here
import '../widgets/global_background.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    Center(child: Text('Switch', style: TextStyle(color: Colors.white, fontSize: 14))),
    ExpensesPage(),
    GroupsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1230),
            Color(0xFF190B28),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: RepaintBoundary(
              child: GlobalBackground(),
            ),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
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
          ),
        ],
      ),
    );
  }
}