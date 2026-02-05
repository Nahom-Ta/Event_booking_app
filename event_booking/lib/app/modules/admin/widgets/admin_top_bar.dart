import 'package:flutter/material.dart';

class AdminTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AdminTopBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(child: Icon(Icons.person)),
        ),
      ],
    );
  }
}
