import 'package:ecommerce/auth/signUpSreen.dart';
import 'package:ecommerce/auth/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/auth/forget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screen/home.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? errorMessage;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> signInEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        errorMessage = null; // clear errors
      });
      Get.to(Wrapper());
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          errorMessage = "No user found for this email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Incorrect password.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Invalid email format.";
        } else {
          errorMessage = e.message; // 👈 show Firebase's actual message
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // fallback for unexpected errors
      });
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );


  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null; // User canceled

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credential for Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),

                    // App name
                    Text(
                      "Shoepify",
                      style: GoogleFonts.pacifico(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Create account text
                    Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Enter your email to sign in for this app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email text field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // Password Field with eye icon
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Align(  // Forgot Password button (aligned to the right)
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (()=>Get.to(ForgetScreen())),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signInEmail();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

// 👇 Add this to show error under button
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],


                    const SizedBox(height: 20),

                    // Divider with "or"
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("or"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OutlinedButton.icon(
                          // onPressed: () async{
                          //   bool isLoggedIn = await login();
                          //
                          //   if (isLoggedIn) {
                          //     Get.offAll(Home());
                          //   }
                          // },
                          onPressed: () async {
                        UserCredential? user = await signInWithGoogle();
                        if (user != null) {
                        Get.offAll(Wrapper());
                        }
                        },
                          icon: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png",
                            height: 20,
                          ),
                          label: Text(
                            "Continue with Google",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Apple button
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.apple,
                              size: 20, color: Colors.black),
                          label: Text(
                            "Continue with Apple",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Register Now button
            Center(
              child: TextButton(
                onPressed: (()=>Get.to(SignUpScreen())),
                  // TODO: Add your "Register Now" logic here
                child: Text("Create New Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Footer - fixed at bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text.rich(
                TextSpan(
                  text: "By reading and accepting our continue, you agree to our ",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
