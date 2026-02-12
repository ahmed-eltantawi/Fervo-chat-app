import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  await googleSignIn.initialize(
    serverClientId:
        "703670720492-m5f6qv65mik327ckvk13o03331rlti6h.apps.googleusercontent.com",
  );

  final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

  final GoogleSignInAuthentication googleAuth = googleUser.authentication;

  final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
