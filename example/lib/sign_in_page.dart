import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'secret_members_only_page.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String errorMessage;

  @override
  void initState() {
    super.initState();
    checkLoggedInState();
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppleSignInButton(
                          style: ButtonStyle.whiteOutline,
                          type: ButtonType.signIn,
                          cornerRadius: 10,
                          onPressed: logIn,
                        ),
                        if (errorMessage != null) Text(errorMessage)
                      ])))),
    );
  }

  void logIn() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        // Store user ID
        await FlutterSecureStorage().write(key: "userId", value: result.credential.user);

        // Navigate to secret page (shhh!)
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => SecretMembersOnlyPage(credential: result.credential)));
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
        print("getCredentialState returned an error: ${credentialState.error.localizedDescription}");
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