import 'package:flutter/widgets.dart';

/// A type for the authorization button.
enum ButtonType {
  defaultButton,
  continueButton,
  signUp
}

/// A style for the authorization button.
enum ButtonStyle {
  black,
  whiteOutline,
  white
}

/// A control you add to your interface that enables users to initiate the Sign In with Apple flow.
class SignInWithAppleButton extends StatelessWidget {
  /// A type for the authorization button.
  final ButtonType type;

  /// A style for the authorization button.
  final ButtonStyle style;

  const SignInWithAppleButton({
    this.type = ButtonType.defaultButton,
    this.style = ButtonStyle.white
  });

  @override
  Widget build(BuildContext context) {
    return null;
  }
}