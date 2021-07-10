import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:yaru/yaru.dart' as yaru;

import '../routes.dart';
import '../widgets/localized_view.dart';
import 'wizard_page.dart';

class WhoAreYouPage extends StatefulWidget {
  const WhoAreYouPage({Key? key}) : super(key: key);

  @override
  _WhoAreYouPageState createState() => _WhoAreYouPageState();
}

enum LoginStrategy { REQUIRE_PASSWORD, AUTO_LOGIN }

class _WhoAreYouPageState extends State<WhoAreYouPage> {
  late LoginStrategy _loginStrategy;
  late TextEditingController _realNameController;
  late TextEditingController _computerNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late MultiValidator _realNameValidator;
  late MultiValidator _computerNameValidator;
  late MultiValidator _usernameValidator;
  late MultiValidator _passwordValidator;

  final _requiredPasswordValidator =
      RequiredValidator(errorText: 'password is required');
  final _minLengthPasswordValidator = MinLengthValidator(2,
      errorText: 'password must be at least 2 digits long');
  final _strongPattenPasswordValidator = PatternValidator(
      r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character');
  final _goodPatternPasswordValidator =
      PatternValidator(r'(^.*(?=.{6,})(?=.*\d).*$)', errorText: 'errorText');

  final _successIcon = Icon(Icons.check_circle, color: yaru.Colors.green);
  final _weakPasswordText = Text('Weak password',
      style: TextStyle(
        color: yaru.Colors.red,
      ));
  final _goodPasswordText = Text('Good password',
      style: TextStyle(
        color: yaru.Colors.orange,
      ));
  final _strongPasswordText = Text('Strong password',
      style: TextStyle(
        color: yaru.Colors.green,
      ));

  final _usernameFormKey = GlobalKey<FormState>();
  final _realNameFormKey = GlobalKey<FormState>();
  final _computerNameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _realNameController = TextEditingController();
    _computerNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _realNameValidator = MultiValidator([
      RequiredValidator(errorText: 'name is required'),
      MinLengthValidator(2, errorText: 'name must be at least 2 digits long')
    ]);
    _computerNameValidator = MultiValidator([
      RequiredValidator(errorText: 'computer name is required'),
      MinLengthValidator(2,
          errorText: 'computer name must be at least 2 digits long')
    ]);
    _usernameValidator = MultiValidator([
      RequiredValidator(errorText: 'username is required'),
      MinLengthValidator(2,
          errorText: 'username must be at least 2 digits long'),
      PatternValidator(
          r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
          errorText: 'invalid username')
    ]);

    _passwordValidator = MultiValidator([
      _requiredPasswordValidator,
      _minLengthPasswordValidator,
    ]);

    _loginStrategy = LoginStrategy.REQUIRE_PASSWORD;
    super.initState();
  }

  Widget findPassWordStrengthLabel(String value) {
    if (_strongPattenPasswordValidator.isValid(value)) {
      return _strongPasswordText;
    } else if (_goodPatternPasswordValidator.isValid(value)) {
      return _goodPasswordText;
    }
    if (_passwordValidator.isValid(value)) {
      return _weakPasswordText;
    }

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    const _screenFactor = 1.6;
    const checkMarksLeftPadding = 10.0;

    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Who are you?'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WhoAreYouInput(
                      formKey: _realNameFormKey,
                      controller: _realNameController,
                      validator: _realNameValidator,
                      label: 'Your name',
                      obscureText: false,
                      successWidget: _successIcon,
                    ),
                    WhoAreYouInput(
                        formKey: _computerNameFormKey,
                        controller: _computerNameController,
                        validator: _computerNameValidator,
                        label: 'Your computers name',
                        successWidget: _successIcon,
                        obscureText: false),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width:
                            MediaQuery.of(context).size.width / _screenFactor,
                        child: Text(
                          'The name it uses when it talks to other computers.',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                    WhoAreYouInput(
                      formKey: _usernameFormKey,
                      controller: _usernameController,
                      validator: _usernameValidator,
                      label: 'Pick a username',
                      obscureText: false,
                      successWidget: _successIcon,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width /
                                _screenFactor,
                            child: Form(
                              key: _passwordFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: _passwordValidator,
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Choose a password'),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _passwordController,
                              builder: (context, value, child) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: checkMarksLeftPadding),
                                    child:
                                        findPassWordStrengthLabel(value.text));
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width /
                                _screenFactor,
                            child: Form(
                              key: _confirmPasswordFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _confirmPasswordController,
                                validator: (val) {
                                  return MatchValidator(
                                          errorText: 'passwords do not match')
                                      .validateMatch(
                                          val!, _passwordController.text);
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm your password'),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _confirmPasswordController,
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: checkMarksLeftPadding),
                                  child:
                                      value.text != _passwordController.text ||
                                              !_passwordValidator
                                                  .isValid(value.text)
                                          ? Text('')
                                          : Icon(Icons.check_circle,
                                              color: yaru.Colors.green),
                                );
                              })
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Radio<LoginStrategy>(
                            value: LoginStrategy.AUTO_LOGIN,
                            groupValue: _loginStrategy,
                            onChanged: (_) => setState(() {
                                  _loginStrategy = LoginStrategy.AUTO_LOGIN;
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('Log in automatically'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio<LoginStrategy>(
                            value: LoginStrategy.REQUIRE_PASSWORD,
                            groupValue: _loginStrategy,
                            onChanged: (_) => setState(() {
                                  _loginStrategy =
                                      LoginStrategy.REQUIRE_PASSWORD;
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('Require my password to log in'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: <WizardAction>[
                WizardAction(
                  label: lang.backButtonText,
                  onActivated: Navigator.of(context).pop,
                ),
                WizardAction(
                  label: lang.startInstallingButtonText,
                  highlighted: true,
                  onActivated: () async {
                    if (_realNameFormKey.currentState!.validate() &&
                        _computerNameFormKey.currentState!.validate() &&
                        _usernameFormKey.currentState!.validate() &&
                        _passwordFormKey.currentState!.validate() &&
                        _confirmPasswordFormKey.currentState!.validate()) {
                      final client =
                          Provider.of<SubiquityClient>(context, listen: false);

                      final key = encrypt.Key.fromLength(32);
                      final iv = encrypt.IV.fromLength(16);
                      final encrypter = encrypt.Encrypter(encrypt.AES(key));

                      final encrypted =
                          encrypter.encrypt(_passwordController.text, iv: iv);

                      await client.setIdentity(IdentityData(
                          hostname: _computerNameController.text,
                          realname: _realNameController.text,
                          username: _usernameController.text,
                          cryptedPassword: encrypted.toString()));

                      Navigator.pushNamed(context, Routes.chooseYourLook);
                    }
                  },
                ),
              ],
            ));
  }
}

class WhoAreYouInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final FieldValidator<String?> validator;
  final String label;
  final bool obscureText;
  final Widget successWidget;

  WhoAreYouInput(
      {Key? key,
      required this.formKey,
      required this.controller,
      required this.validator,
      required this.label,
      required this.obscureText,
      required this.successWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.6,
            child: Form(
              key: formKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller,
                validator: validator,
                obscureText: obscureText,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: label),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                return Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: !validator.isValid(value.text)
                        ? Text('')
                        : successWidget);
              })
        ],
      ),
    );
  }
}
