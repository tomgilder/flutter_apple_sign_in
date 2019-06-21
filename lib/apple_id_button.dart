import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;
  
    /// A type for the authorization button.
  final ButtonType type;

  /// A style for the authorization button.
  final ButtonStyle style;  

  /// A custom corner radius to be used by this button.
  final double cornerRadius;

  SignInWithAppleButton({
    this.onPressed,
    this.type = ButtonType.defaultButton,
    this.style = ButtonStyle.white,
    this.cornerRadius = 4
  });

  MethodChannel _channel;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 50, maxHeight: 50),
      child: UiKitView(
          viewType: "dev.gilder.tom/apple_id_button",
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: _buildCreationParams(),
          onPlatformViewCreated: _createMethodChannel),
    );
  }

  Map<String, dynamic> _buildCreationParams() {
    return {
      "buttonType": type.toString(),
      "buttonStyle": style.toString(),
      "cornerRadius": cornerRadius,
      "enabled": onPressed != null
    };
  }

  void _createMethodChannel(int nativeViewId) {
    _channel = MethodChannel("dev.gilder.tom/sign_in_with_apple_button_$nativeViewId")
      ..setMethodCallHandler(_onMethodCall);
  }

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onTapped":
        _onTapped();
        return null;
    }

    throw MissingPluginException("SignInWithAppleButton._onMethodCall: no handler for ${call.method}");
  }

  void _onTapped() {
    if (onPressed != null) {
      onPressed();
    }
  }
}