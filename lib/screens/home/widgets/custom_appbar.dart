import 'package:attendance_register/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      leading: IconButton(
        // Hamburger menu icon
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton(
          // User icon
          icon: Icon(
            Icons.account_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}
