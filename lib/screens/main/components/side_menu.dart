import 'package:admin/constants.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/Config.dart';

class SideMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    if (Config.get('userLevel') == 'admin') {
      return SideMenuStateAdmin();
    } else {
      return SideMenuStateMember();
    }
  }

  const SideMenu({
    Key? key,
    required this.setScreen,
  }) : super(key: key);

  final Function(int) setScreen;
}

extension AddGet<T> on Iterable<T> {
  List<T> addIfGet(dynamic condition, T e) {
    this.toList().addIf(condition, e);
    return this.toList();
  }
}

class SideMenuStateAdmin extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBgColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Festa",
            icon: Icons.info,
            press: () {
              setState(() => widget.setScreen(0));
            },
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {
              Get.to(() => ViewerScreen());
            },
          ),
          DrawerListTile(
            title: "Lista",
            icon: Icons.list,
            press: () {
              setState(() => widget.setScreen(1));
            },
          ),
          DrawerListTile(
            title: "Inventario",
            icon: Icons.pallet,
            press: () {
              setState(() => widget.setScreen(2));
            },
          ),
          DrawerListTile(
            title: "Prodotti",
            icon: Icons.shopping_bag,
            press: () {
              setState(() => widget.setScreen(3));
            },
          ),
          DrawerListTile(
            title: "Turni",
            icon: Icons.work_history,
            press: () {
              setState(() => widget.setScreen(4));
            },
          ),
          DrawerListTile(
            title: "Cassa",
            icon: Icons.euro,
            press: () {
              setState(() => widget.setScreen(5));
            },
          ),
          DrawerListTile(
            title: "Telecamera",
            icon: Icons.security,
            press: () {
              setState(() => widget.setScreen(6));
            },
          ),
          Spacer(),
          DrawerListTile(
            title: "Admin",
            icon: Icons.admin_panel_settings,
            press: () {
              setState(() => widget.setScreen(7));
            },
          ),
          DrawerListTile(
            title: "Impostazioni",
            icon: Icons.settings,
            press: () {
              setState(() => widget.setScreen(8));
            },
          ),
        ],
      ),
    );
  }
}

class SideMenuStateMember extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Festa",
            icon: Icons.info,
            press: () {
              setState(() => widget.setScreen(0));
            },
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {
              Get.to(() => ViewerScreen());
            },
          ),
          DrawerListTile(
            title: "Lista",
            icon: Icons.list,
            press: () {
              setState(() => widget.setScreen(1));
            },
          ),
          DrawerListTile(
            title: "Inventario",
            icon: Icons.pallet,
            press: () {
              setState(() => widget.setScreen(2));
            },
          ),
          DrawerListTile(
            title: "Prodotti",
            icon: Icons.shopping_bag,
            press: () {
              setState(() => widget.setScreen(3));
            },
          ),
          DrawerListTile(
            title: "Turni",
            icon: Icons.work_history,
            press: () {
              setState(() => widget.setScreen(4));
            },
          ),
          DrawerListTile(
            title: "Cassa",
            icon: Icons.euro,
            press: () {
              setState(() => widget.setScreen(5));
            },
          ),
          DrawerListTile(
            title: "Telecamera",
            icon: Icons.security,
            press: () {
              setState(() => widget.setScreen(6));
            },
          ),
          Spacer(),
          DrawerListTile(
            title: "Impostazioni",
            icon: Icons.settings,
            press: () {
              setState(() => widget.setScreen(8));
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      required this.title,
      required this.press,
      required this.icon,
      this.enabled = true})
      : super(key: key);

  final String title;
  final VoidCallback press;
  final bool enabled;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      enabled: enabled,
      horizontalTitleGap: kDefaultPadding,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey.withOpacity(0.9),
            size: 24,
          ),
        ],
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
