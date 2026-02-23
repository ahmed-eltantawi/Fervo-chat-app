import 'package:chat_with_me_now/Views/acount_view.dart';
import 'package:chat_with_me_now/Views/settings_view.dart';
import 'package:chat_with_me_now/Views/sign_in_view.dart';
import 'package:chat_with_me_now/Widgets/app_icon_widget.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
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
            AppIconWidget(),
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
              onTap: () {
                showAlertDialog(context);
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

void showAlertDialog(BuildContext context) {
  var colorRecord = (purple: Color(0xff43169C), white: Color(0xffF1F5F9));

  // set up the buttons
  _CustomBottom logOutButton = _CustomBottom(
    text: "Log Out",
    color: colorRecord.purple,
    onTap: () async {
      Navigator.pushNamedAndRemoveUntil(context, SignIn.id, (route) => false);
      await FirebaseAuth.instance.signOut();
    },
  );
  _CustomBottom cancelButton = _CustomBottom(
    text: "Cancel",
    color: colorRecord.white,
    onTap: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
    content: Text(
      "Are you sure you want to log out of Fervo?",
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    ),
    actions: [logOutButton, cancelButton],
    icon: CircleAvatar(
      minRadius: 32,
      backgroundColor: Color(0xffECE7F5),
      child: Icon(
        Icons.logout,
        color: context.onPrimary,
        size: 30,
        fontWeight: FontWeight.w600,
      ),
    ),
    actionsOverflowButtonSpacing: 10,
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _CustomBottom extends StatelessWidget {
  const _CustomBottom({
    super.key,
    required this.text,
    this.onTap,
    required this.color,
  });
  final String text;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: context.onPrimary.withValues(alpha: 0.35),
              spreadRadius: 0.5,
              blurRadius: 15,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,

                color: color == Color(0xff43169C)
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
