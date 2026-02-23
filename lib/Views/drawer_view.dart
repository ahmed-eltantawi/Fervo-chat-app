import 'package:chat_with_me_now/Views/acount_view.dart';
import 'package:chat_with_me_now/Views/sign_in_view.dart';
import 'package:chat_with_me_now/Views/settings_view.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
        child: Column(
          children: [
            SizedBox(height: 50),

            CircleAvatar(backgroundImage: AssetImage(kAppIcon), radius: 50),
            SizedBox(height: 10),
            Text(
              'Fervo Chat',
              style: TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text(
                  'HOME',
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
                ),
                leading: Icon(Icons.home, size: 25),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AccountView.id);
              },
              child: ListTile(
                title: Text(
                  'ACCOUNT',
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
                ),
                leading: Icon(Icons.person_4, size: 25),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsView();
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  'SETTINGS',
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
                ),
                leading: Icon(Icons.settings, size: 25),
              ),
            ),

            Spacer(flex: 1),
            GestureDetector(
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignIn.id,
                  (route) => false,
                );
                await FirebaseAuth.instance.signOut();
              },

              child: ListTile(
                title: Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    letterSpacing: 3,
                  ),
                ),
                leading: Icon(Icons.logout, color: Colors.red, size: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
