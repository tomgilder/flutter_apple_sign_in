import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/apple_id_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sign_in_with_apple/authorization_scope.dart';
import 'package:sign_in_with_apple/apple_id_request.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In with Apple Example App'),
        ),
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
                    width: 280,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // Current sign in status
                          FutureBuilder(
                            future: SignInWithApple.getCredentialState("userId"),
                            builder: (context, AsyncSnapshot<CredentialState> snapshot) {
                              if (!snapshot.hasData) {
                                return Text("Loading...");
                              }

                              switch (snapshot.data.status) {
                                case CredentialStatus.authorized:
                                  return Text("Authorized");

                                case CredentialStatus.revoked:
                                  return Text("Revoked");

                                case CredentialStatus.notFound:
                                  return Text("Not found");

                                case CredentialStatus.error:
                                  return Text("Error");
                              }
                            },
                          ),

                          SizedBox(height: 50,),

                          // Sign in button
                          SignInWithAppleButton(
                            style: ButtonStyle.whiteOutline,
                            type: ButtonType.signUp,
                            cornerRadius: 10,
                            onPressed: () async {
                              final result = await SignInWithApple.performRequests([
                                AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
                              ]);

                              if (result.status == AuthorizationStatus.authorized) {
                                print(result.credential.email);
                              }
                            },
                          ),
                        ])))),
      ),
    );
  }
}
