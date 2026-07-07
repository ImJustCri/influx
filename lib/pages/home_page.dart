import 'package:flutter/material.dart';
import 'package:influx/widgets/home_app_bar.dart';
import 'package:influx/widgets/page_padding.dart';
import '../widgets/app_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeAppBar(),
        PagePadding(
          child: AppContainer(
            child: const Text('Hello', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}