import 'package:flutter/material.dart';

import '../model/user.dart';

class UserInfoPage extends StatelessWidget {
  final User userInfo;
  const UserInfoPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        centerTitle: true,
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [           
            ListTile(
              title: Text(
                userInfo.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: userInfo.story.trim().isNotEmpty
                  ? Text(userInfo.story)
                  : null,
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              trailing: userInfo.country.trim().isNotEmpty
                  ? Text(userInfo.country)
                  : null,
            ),

            ListTile(
              title: Text(
                userInfo.phone,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
            ),

            if (userInfo.email.trim().isNotEmpty)
              ListTile(
                title: Text(
                  userInfo.email,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.mail,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}