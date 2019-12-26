import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppleSignInLocalizations {
  AppleSignInLocalizations(this.locale);

  final Locale locale;

  static AppleSignInLocalizations of(BuildContext context) {
    return Localizations.of<AppleSignInLocalizations>(context, AppleSignInLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    // TODO add other languages
    'en': {
      'defaultButton': 'Sign in with Apple',
      'continueButton': 'Continue with Apple',
    },
    'ja': {
      'defaultButton': 'Appleでサインイン',
      'continueButton': 'Appleで続ける',
    },
  };

  String get defaultButton {
    return _localizedValues[locale.languageCode]['defaultButton'];
  }

  String get continueButton {
    return _localizedValues[locale.languageCode]['continueButton'];
  }
}

class AppleSignInLocalizationsDelegate extends LocalizationsDelegate<AppleSignInLocalizations> {
  const AppleSignInLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppleSignInLocalizations> load(Locale locale) {
    return SynchronousFuture<AppleSignInLocalizations>(AppleSignInLocalizations(locale));
  }

  @override
  bool shouldReload(AppleSignInLocalizationsDelegate old) => false;
}