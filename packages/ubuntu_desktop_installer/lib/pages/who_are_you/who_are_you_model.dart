import 'package:flutter/material.dart';
import 'package:subiquity_client/subiquity_client.dart';

///
class WhoAreYouModel extends ChangeNotifier {
  ///
  // ignore: unused_field
  final SubiquityClient _client;

  ///
  LoginStrategy get loginStrategy => _loginStrategy.value;
  final _loginStrategy =
      ValueNotifier<LoginStrategy>(LoginStrategy.requirePassword);
  set loginStrategy(LoginStrategy value) => _loginStrategy.value = value;

  ///
  String get realName => _realName.value;
  final _realName = ValueNotifier<String>('');
  set realName(String value) => _realName.value = value;

  ///
  String get hostName => _hostName.value;
  final _hostName = ValueNotifier<String>('');
  set hostName(String value) => _hostName.value = value;

  ///
  String get username => _username.value;
  final _username = ValueNotifier<String>('');
  set username(String value) => _username.value = value;

  ///
  String get password => _password.value;
  final _password = ValueNotifier<String>('');
  set password(String value) => _password.value = value;

  ///
  WhoAreYouModel(this._client) {
    Listenable.merge(
            [_loginStrategy, _realName, _hostName, _username, _password])
        .addListener(notifyListeners);
  }

  ///
  Future<void> loadProfileSetup() async {}
}

/// An enum for storing the login strategy.
enum LoginStrategy {
  /// If selected can be used for the representation
  /// of the user preference to always entering the password
  /// at login.
  requirePassword,

  /// If selected can be used for the representation
  /// of the user preference to log in without a password.
  autoLogin
}
