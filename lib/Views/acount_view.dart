import 'package:chat_with_me_now/Views/updata_profile_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});
  static String id = 'AccountView';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('id', isEqualTo: user.email)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _defaultAvatar(context);
                }

                final data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                final image = data['image'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpDataProfilePhoto(),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: AlignmentGeometry.xy(.75, 1.09),

                    // AlignmentGeometry.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 101,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.inversePrimary,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: image == null || image == ''
                              ? const AssetImage('assets/images/profile.jpg')
                              : NetworkImage(image),
                        ),
                      ),
                      Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            Text(user.displayName ?? '', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(user.email ?? '', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 101,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      child: const CircleAvatar(
        radius: 100,
        backgroundImage: AssetImage('assets/images/profile.jpg'),
      ),
    );
  }
}
