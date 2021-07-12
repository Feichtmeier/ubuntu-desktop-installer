import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:subiquity_client/subiquity_client.dart';

import '../routes.dart';
import '../widgets/localized_view.dart';
import '../widgets/validated_input.dart';
import 'wizard_page.dart';

/// The installer page for setting up the user data.
///
/// It uses [WizardPage] and [WizardAction] to create an installer page.
class WhoAreYouPage extends StatefulWidget {
  /// Creates a the installer page for setting up the user data.
  const WhoAreYouPage({Key? key}) : super(key: key);

  @override
  _WhoAreYouPageState createState() => _WhoAreYouPageState();
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

class _WhoAreYouPageState extends State<WhoAreYouPage> {
  late LoginStrategy _loginStrategy;
  late TextEditingController _realNameController;
  late TextEditingController _computerNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

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

    _loginStrategy = LoginStrategy.requirePassword;
    super.initState();
  }

  Widget findPassWordStrengthLabel(
      BuildContext context,
      String value,
      String weakPasswordLabel,
      String averagePasswordLabel,
      String strongPasswordLabel) {
    final strongPattenPasswordValidator =
        PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: '');
    final goodPatternPasswordValidator =
        PatternValidator(r'(^.*(?=.{6,})(?=.*\d).*$)', errorText: '');
    final weakPasswordValidator = MultiValidator([
      RequiredValidator(errorText: ''),
      MinLengthValidator(2, errorText: ''),
    ]);

    if (strongPattenPasswordValidator.isValid(value)) {
      return Text(strongPasswordLabel,
          style: TextStyle(
            color: Theme.of(context)
                .elevatedButtonTheme
                .style!
                .backgroundColor!
                .resolve({MaterialState.pressed}),
          ));
    } else if (goodPatternPasswordValidator.isValid(value)) {
      return Text(averagePasswordLabel,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ));
    }
    if (weakPasswordValidator.isValid(value)) {
      return Text(weakPasswordLabel,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ));
    }

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    const screenFactor = 1.6;
    const checkMarksLeftPadding = 10.0;
    final successIcon = Icon(Icons.check_circle,
        color: Theme.of(context)
            .elevatedButtonTheme
            .style!
            .backgroundColor!
            .resolve({MaterialState.focused}));

    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text(lang.whoAreYouPageTitle),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ValidatedInput(
                        width: MediaQuery.of(context).size.width / screenFactor,
                        spacing: checkMarksLeftPadding,
                        formKey: _realNameFormKey,
                        controller: _realNameController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: lang
                                  .whoAreYouPageRealNameRequiredValidatorErrorText),
                          MinLengthValidator(2,
                              errorText: lang
                                  .whoAreYouPageRealNameMinLengthValidatorErrorText)
                        ]),
                        label: lang.whoAreYouPageRealNameLabel,
                        obscureText: false,
                        successWidget: successIcon,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ValidatedInput(
                          width:
                              MediaQuery.of(context).size.width / screenFactor,
                          spacing: checkMarksLeftPadding,
                          formKey: _computerNameFormKey,
                          controller: _computerNameController,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: lang
                                    .whoAreYouPageComputerNameRequiredValidatorErrorText),
                            MinLengthValidator(2,
                                errorText: lang
                                    .whoAreYouPageComputerNameMinLengthValidatorErrorText)
                          ]),
                          label: lang.whoAreYouPageComputerNameLabel,
                          successWidget: successIcon,
                          obscureText: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / screenFactor,
                        child: Text(
                          lang.whoAreYouPageComputerNameInfo,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ValidatedInput(
                        width: MediaQuery.of(context).size.width / screenFactor,
                        spacing: checkMarksLeftPadding,
                        formKey: _usernameFormKey,
                        controller: _usernameController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: lang
                                  .whoAreYouPageUsernameRequiredValidatorErrorText),
                          MinLengthValidator(2,
                              errorText: lang
                                  .whoAreYouPageUsernameMinLengthValidatorErrorText),
                          PatternValidator(
                              r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
                              errorText: lang
                                  .whoAreYouPageUsernamePatternValidatorErrorText)
                        ]),
                        label: lang.whoAreYouPageUsernameLabel,
                        obscureText: false,
                        successWidget: successIcon,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width /
                                screenFactor,
                            child: Form(
                              key: _passwordFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: lang
                                          .whoAreYouPagePasswordRequiredValidatorErrorText),
                                  MinLengthValidator(2,
                                      errorText: lang
                                          .whoAreYouPagePasswordMinLengthValidatorErrorText),
                                ]),
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: lang.whoAreYouPagePasswordLabel),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _passwordController,
                              builder: (context, value, child) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: checkMarksLeftPadding),
                                    child: findPassWordStrengthLabel(
                                        context,
                                        value.text,
                                        lang.whoAreYouPagePasswordWeakPasswordLabel,
                                        lang.whoAreYouPagePasswordAveragePasswordLabel,
                                        lang.whoAreYouPagePasswordStrongPasswordLabel));
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
                                screenFactor,
                            child: Form(
                              key: _confirmPasswordFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _confirmPasswordController,
                                validator: (val) {
                                  return MatchValidator(
                                          errorText: lang
                                              .whoAreYouPageConfirmPasswordValidatorErrorText)
                                      .validateMatch(
                                          val!, _passwordController.text);
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText:
                                        lang.whoAreYouPageConfirmPasswordLabel),
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
                                              !MultiValidator([
                                                RequiredValidator(
                                                    errorText: lang
                                                        .whoAreYouPagePasswordRequiredValidatorErrorText),
                                                MinLengthValidator(2,
                                                    errorText: lang
                                                        .whoAreYouPagePasswordMinLengthValidatorErrorText),
                                              ]).isValid(value.text)
                                          ? Text('')
                                          : successIcon,
                                );
                              })
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Radio<LoginStrategy>(
                            value: LoginStrategy.autoLogin,
                            groupValue: _loginStrategy,
                            onChanged: (_) => setState(() {
                                  _loginStrategy = LoginStrategy.autoLogin;
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(lang.whoAreYouPageLoginStrategyAutoLogin),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio<LoginStrategy>(
                            value: LoginStrategy.requirePassword,
                            groupValue: _loginStrategy,
                            onChanged: (_) => setState(() {
                                  _loginStrategy =
                                      LoginStrategy.requirePassword;
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              lang.whoAreYouPageLoginStrategyRequirePassword),
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
