import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../database/register.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userEmail;
  final String title;

  const MyAppBar({
    Key? key,
    this.userEmail,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        userEmail != null
            ? FutureBuilder<Uint8List?>(
                future: DatabaseHelper.getUserProfilePicture(userEmail ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.error),
                    );
                  } else {
                    final profilePicture = snapshot.data;
                    return profilePicture != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundImage: MemoryImage(profilePicture),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.person),
                          );
                  }
                },
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
