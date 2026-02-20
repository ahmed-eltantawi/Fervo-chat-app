// import 'package:chat_with_me_now/Views/error_view.dart';
// import 'package:chat_with_me_now/Views/otp_view.dart';
// import 'package:chat_with_me_now/Widgets/app_icon_widget.dart';
// import 'package:chat_with_me_now/Widgets/custom_bottom.dart';
// import 'package:chat_with_me_now/Widgets/custom_text_field.dart';
// import 'package:chat_with_me_now/helper/extensions.dart';
// import 'package:chat_with_me_now/auth/isTheEmailExists.dart';
// import 'package:chat_with_me_now/helper/show_snack_bar.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:vibration/vibration.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});
//   static String id = 'RegisterView';

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   String? email;

//   String? password;
//   String? userName;

//   final GlobalKey<FormState> formKey = GlobalKey();

//   bool isLoading = false;
//   bool passwordHide = true;

//   IconData passwordIcon = Icons.visibility_off_outlined;

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: isLoading,
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Form(
//               key: formKey,
//               child: ListView(
//                 children: [
//                   SizedBox(height: 100),
//                   AppIconWidget(),
//                   Row(
//                     children: [
//                       Text('Register', style: TextStyle(fontSize: 25)),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       SizedBox(height: 10),
//                       CustomFormTextField(
//                         prefixIcon: Icons.person,
//                         textInputAction: TextInputAction.next,
//                         hintText: 'Your Name',
//                         onChanged: (value) {
//                           userName = value.capitalize();
//                         },
//                       ),
//                       SizedBox(height: 15),
//                       CustomFormTextField(
//                         prefixIcon: Icons.email_outlined,
//                         textInputAction: TextInputAction.next,
//                         hintText: 'Email',
//                         onChanged: (value) {
//                           email = value.toLowerCase();
//                         },
//                       ),
//                       SizedBox(height: 15),
//                       Stack(
//                         alignment: AlignmentGeometry.centerRight,
//                         children: [
//                           CustomFormTextField(
//                             prefixIcon: Icons.lock_outlined,
//                             textInputAction: TextInputAction.done,
//                             hide: passwordHide,
//                             hintText: '********',
//                             onChanged: (value) {
//                               password = value;
//                             },
//                           ),

//                           IconButton(
//                             onPressed: () {
//                               if (passwordIcon ==
//                                   Icons.visibility_off_outlined) {
//                                 passwordIcon = Icons.remove_red_eye_outlined;
//                                 passwordHide = false;
//                               } else {
//                                 passwordIcon = Icons.visibility_off_outlined;
//                                 passwordHide = true;
//                               }
//                               setState(() {
//                                 passwordIcon;
//                                 passwordHide;
//                               });
//                             },
//                             icon: Icon(
//                               passwordIcon,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   CustomBottom(
//                     text: 'Register',
//                     onTap: () async {
//                       setState(() {
//                         isLoading = true;
//                       });
//                       final bool isConnected =
//                           await InternetConnection().hasInternetAccess;
//                       if (!isConnected) {
//                         showSnackBar(context, 'No internet connection.');
//                         vibration();
//                       } else {
//                         if (formKey.currentState!.validate()) {
//                           if (!EmailValidator.validate(email!)) {
//                             vibration();

//                             showSnackBar(
//                               context,
//                               'Email is not valid email, try To enter a right one',
//                             );
//                           }

//                           if (await isThisEmailExists(email!)) {
//                             vibration();
//                             showSnackBar(
//                               context,
//                               "This Email ID already Associated with Another Account.",
//                             );
//                           } else {
//                             try {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) {
//                                     return OTPView(
//                                       email: email!,
//                                       password: password!,
//                                       userName: userName!,
//                                     );
//                                   },
//                                 ),
//                               );
//                             } on FirebaseAuthException catch (e) {
//                               vibration();

//                               if (e.code == 'weak-password') {
//                                 showSnackBar(
//                                   context,
//                                   'The password provided is too weak.',
//                                 );
//                               } else if (e.code == 'email-already-in-use') {
//                                 showSnackBar(
//                                   context,
//                                   'The account already exists for that email.',
//                                 );
//                               }
//                             } catch (e) {
//                               vibration();

//                               showSnackBar(
//                                 context,
//                                 'There some thing Wrong, please try again',
//                               );
//                             }
//                           }
//                         } else if (email != null &&
//                             userName != null &&
//                             password != null) {
//                           vibration();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) {
//                                 return ErrorView();
//                               },
//                             ),
//                           );
//                         }
//                       }
//                       setState(() {
//                         isLoading = false;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Already Have an account?  ", style: TextStyle()),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           "Sign In",
//                           style: TextStyle(fontWeight: FontWeight.w700),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void vibration() async {
//     if (await Vibration.hasVibrator()) {
//       Vibration.vibrate();
//     }
//   }
// }
