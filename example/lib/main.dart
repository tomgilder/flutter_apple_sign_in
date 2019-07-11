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

  AuthorizationResult authorizationResult;

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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
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
                          ),

                          SizedBox(height:40),

                          SignInWithAppleButton(
                            style: ButtonStyle.whiteOutline,
                            type: ButtonType.signUp,
                            cornerRadius: 10,
                            onPressed: () async {
                              final result = await SignInWithApple.performRequests([
                                AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
                              ]);

                              setState(() => authorizationResult = result);
                            },
                          ),

                          SizedBox(height:40),

                          if (authorizationResult?.status == AuthorizationStatus.authorized)
                            Text("performRequests returned authorized:\nemail: ${authorizationResult?.credential?.email}\ngivenName:${authorizationResult?.credential?.fullName?.givenName}\nuser: ${authorizationResult?.credential?.user}"),

                          if (authorizationResult?.status == AuthorizationStatus.error)
                            Text("performRequests returned error: ${authorizationResult?.error?.localizedDescription}"),
                          
                        ])))),
      ),
    );
  }
}
