import 'package:flutter/material.dart';
import 'package:influx/pages/switch/fuel_page.dart';
import 'package:influx/pages/switch/groceries_page.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../widgets/switch/main_page/eco_switch_tab.dart';
import '../../widgets/switch/main_page/savings_tab.dart';
import '../../widgets/switch/main_page/switch_app_bar.dart';
import '../../widgets/switch/main_page/tab_navigation_bar.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  int _selectedTabIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEcoSwitch = _selectedTabIndex == 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.transparent,
        gradient: isEcoSwitch
            ? LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4CAF50).withValues(alpha: 0.15),
            const Color(0xFF4CAF50).withValues(alpha: 0.02),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        )
            : null,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const SwitchAppBar(),
        body: Column(
          children: [
            PagePadding(
              child: TabNavigationBar(
                selectedTabIndex: _selectedTabIndex,
                onTabTapped: _onTabTapped,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                children: [
                  PagePadding(
                    child: SavingsTab(
                      onFuelTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FuelPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  PagePadding(
                    child: EcoSwitchTab(
                      onGroceriesTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GroceriesPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}