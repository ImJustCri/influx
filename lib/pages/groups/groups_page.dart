import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/groups/group_detail_page.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';

import '../../theme.dart';
import '../../widgets/group_tile.dart';
import '../../widgets/settings_tile.dart';
import 'enter_group.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text('I miei gruppi', style: AppTypography.pageTitle),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: PagePadding(
        child: Column(
          spacing: 24,
          children: [
            AppContainer(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  GroupTile(
                    icon: LucideIcons.plus,
                    title: "Famiglia",
                    members: 2,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetailPage()));
                    }
                  ),
                  GroupTile(
                    icon: LucideIcons.plus,
                    title: "Amici viaggio",
                    members: 5,
                    onTap: () {

                    },
                  ),
                ],
              )
            ),
            Text("Vuoi fare parte di un'altro gruppo?", style: AppTypography.containerBody),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: SettingsTile(
                    icon: LucideIcons.plus,
                    title: "Crea",
                    onTap: () {

                    },
                  ),
                ),
                Expanded(
                  child: SettingsTile(
                    icon: LucideIcons.door_open,
                    title: "Entra",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EnterGroupPage()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
