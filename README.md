# Apple Sign In - Flutter Plugin

Access [Sign In with Apple](https://developer.apple.com/sign-in-with-apple/) from Flutter.

⚠️ This plugin is still in development and APIs will probably still change ⚠️

## Platform support

This plugin currently only supports iOS. There's a [JavaScript framework](https://developer.apple.com/documentation/signinwithapplejs) for Android.

## To Do

* Documentation
* Support for iOS 12 and below, including an `isAvailable()` method to check if sign in is available
* Flutter widget version of the "Sign in With Apple" button, to avoid the cost of creating a UIKit view

## Implementing

1. [Configure your app](https://help.apple.com/developer-account/#/devde676e696) in Xcode to add the "Sign In with Apple" capability
2. Enable Flutter platform views: in your app's Info.plist, add a boolean field with the key `io.flutter.embedded_views_preview` with the value `YES`
3. See [the example app](https://github.com/tomgilder/flutter_apple_sign_in/blob/master/example/lib/sign_in_page.dart) to see how the API works