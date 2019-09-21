import 'package:apple_sign_in_example/button_test/button_test_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'secret_members_only_page.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Future<bool> _isAvailableFuture = AppleSignIn.isAvailable();

  String errorMessage;

  @override
  void initState() {
    super.initState();
    checkLoggedInState();

    AppleSignIn.onCredentialRevoked.listen((_) {
      print("Credentials revoked");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In with Apple Example App'),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  width: 280,
                  child: FutureBuilder<bool>(
                    future: _isAvailableFuture,
                    builder: (context, isAvailableSnapshot) {
                      if (!isAvailableSnapshot.hasData) {
                        return Container(child: Text('Loading...'));
                      }

                      return isAvailableSnapshot.data
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppleSignInButton(),
                                  if (errorMessage != null)
                                    Text(errorMessage),
                                  SizedBox(
                                    height: 500,
                                  ),
                                  RaisedButton(
                                    child: Text("Button Test Page"),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => ButtonTestPage()));
                                    },
                                  )
                                ])
                          : Text('Sign in With Apple not available. Must be run on iOS 13+');
                    },
                  )))),
    );
  }

  void logIn() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        // Store user ID
        await FlutterSecureStorage()
            .write(key: "userId", value: result.credential.user);

        // Navigate to secret page (shhh!)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) =>
                SecretMembersOnlyPage(credential: result.credential)));
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        setState(() {
          errorMessage = "Sign in failed 😿";
        });
        break;
    }
  }

  void checkLoggedInState() async {
    final userId = await FlutterSecureStorage().read(key: "userId");
    if (userId == null) {
      print("No stored user ID");
      return;
    }

    final credentialState = await AppleSignIn.getCredentialState(userId);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        print("getCredentialState returned authorized");
        break;

      case CredentialStatus.error:
        print(
            "getCredentialState returned an error: ${credentialState.error.localizedDescription}");
        break;

      case CredentialStatus.revoked:
        print("getCredentialState returned revoked");
        break;

      case CredentialStatus.notFound:
        print("getCredentialState returned not found");
        break;
    }
  }
}
