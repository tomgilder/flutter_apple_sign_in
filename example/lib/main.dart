import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/apple_id_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sign_in_with_apple/apple_id_provider.dart';
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
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await SignInWithApple.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
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
                          // SignInWithAppleButton(
                          //   style: ButtonStyle.black,
                          //   type: ButtonType.continueButton,
                          //   onPressed: () => print("tapped 1"),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // SignInWithAppleButton(
                          //   style: ButtonStyle.white,
                          //   type: ButtonType.defaultButton,
                          //   onPressed: () => print("tapped 2"),
                          // ),
                          SizedBox(
                            height: 50,
                          ),

                          SignInWithAppleButton(
                            style: ButtonStyle.whiteOutline,
                            type: ButtonType.signUp,
                            cornerRadius: 10,
                            onPressed: () async {

                              final result = await SignInWithApple.performRequests(
                                [AppleIdRequest(
                                  requestedScopes: [
                                    Scope.email,
                                    Scope.fullName])]
                              );
                              
                              if (result.status == AuthorizationStatus.authorized) {
                                print(result.credential.email);
                              }
                            },


                          ),
                        ])))),
      ),
    );
  }

  // void _getSignInState() async {
  //   final state = await AppleIdProvider.getCredentialState("userId");
  // }

  // void _signInWithAppleButtonPress() {
  //   final request = await AppleIdProvider.request(
  //     scopes: [Scope.email, Scope.fullName]
  //   );
  //   // request.
  // }
}
