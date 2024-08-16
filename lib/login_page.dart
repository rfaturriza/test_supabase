import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // state variables
  bool isLoading = false;
  String email = '';
  String password = '';

  Future<bool> signInWithKeycloak() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.keycloak,
      scopes: 'openid',
    );
  }

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes in order to detect when ther OAuth login is complete.
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      print('Auth Session: ${data.session.toString()}');
      print('Auth Event: $event');
      if (event == AuthChangeEvent.signedIn) {
        GoRouter.of(context).pushReplacement('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  final signIn = await supabase.auth.signInWithPassword(
                    email: email,
                    password: password,
                  );
                  if (signIn.user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Signed in as ${signIn.user!.email}"),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login with Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await signInWithKeycloak();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );
                }
              },
              child: const Text('Login with Keycloak'),
            ),
            // logout
            ElevatedButton(
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  await supabase.auth.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Signed out"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
