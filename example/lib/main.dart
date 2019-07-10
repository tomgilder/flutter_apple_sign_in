import 'package:flutter/material.dart';
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

    final userId = "userId";

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
                            future: SignInWithApple.getCredentialState(userId),
                            builder: (context, AsyncSnapshot<CredentialState> snapshot) {
                              if (!snapshot.hasData) {
                                return Text("Loading...");
                              }

                              switch (snapshot.data.status) {
                                case CredentialStatus.authorized:
                                  return Text("getCredentialState returned authorized for '$userId'");

                                case CredentialStatus.revoked:
                                  return Text("getCredentialState returned revoked for '$userId'");

                                case CredentialStatus.notFound:
                                  return Text("getCredentialState returned not found for '$userId'");

                                case CredentialStatus.error:
                                  return Text("getCredentialState returned error for '$userId': ${snapshot.data.error}");
                              }

                              return Text("Unknown state");
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

                              switch (result.status) {
                                case AuthorizationStatus.authorized:
                                  print("performRequests returned authorized: '${result.credential.user}'");
                                  break;

                                case AuthorizationStatus.error:
                                  print("performRequests returned error: ${result.error.localizedDescription}");
                                  break;
                              }

                              if (result.status == AuthorizationStatus.authorized) {
                                print(result.credential.email);
                              }
                            },
                          )
                        ])))),
      ),
    );
  }
}
