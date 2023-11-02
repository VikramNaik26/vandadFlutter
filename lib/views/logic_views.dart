import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_start/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: "Email",
                  ),
                ),
                TextField(
                  controller: _password,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    labelText: "Password",
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      try {
                        final UserCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);

                        print(UserCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "invalid-login-credentials") {
                          print("User not found");
                        } else if (e.code == "wrong-password") {
                          print("wrong-password");
                          /* print("Something went wrong");
                          print(e.code);
                          print(e.stackTrace); */
                        }
                      }
                    },
                    child: Text("Login")),
              ]);
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
