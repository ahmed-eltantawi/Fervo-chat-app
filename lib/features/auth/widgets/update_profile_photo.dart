import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpDataProfilePhoto extends StatelessWidget {
  const UpDataProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),

              decoration: InputDecoration(
                hintText: 'Enter URL of profile photo',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) async {
                if (value.trim().isEmpty) return;

                try {
                  final query = await FirebaseFirestore.instance
                      .collection('users')
                      .where('id', isEqualTo: user.email)
                      .limit(1)
                      .get();

                  if (query.docs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not found')),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(query.docs.first.id)
                      .update({'image': value.trim()});

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error updating profile image'),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
