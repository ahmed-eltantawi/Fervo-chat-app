import 'package:chat_with_me_now/auth/make_user_and_sing_in_function.dart';
import 'package:chat_with_me_now/auth/user_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> registerFunction({context, email, password, userName}) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  await userLogin(context, email, password);
  await makeUser(context, email, password, userName);
}
