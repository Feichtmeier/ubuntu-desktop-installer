import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_desktop_installer/pages/wizard_page.dart';
import 'package:ubuntu_desktop_installer/widgets/localized_view.dart';
import 'package:yaru/yaru.dart' as yaru;

import '../routes.dart';

class WhoAreYouPage extends StatefulWidget {
  const WhoAreYouPage({Key? key}) : super(key: key);

  @override
  _WhoAreYouPageState createState() => _WhoAreYouPageState();
}

enum LoginStrategy { REQUIRE_PASSWORD, AUTO_LOGIN }

class _WhoAreYouPageState extends State<WhoAreYouPage> {
  final avatars = [1, 2, 3, 4, 5];
  late LoginStrategy loginStrategy;
  late TextEditingController realNameController;
  late TextEditingController computerNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    realNameController = TextEditingController();
    computerNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    loginStrategy = LoginStrategy.REQUIRE_PASSWORD;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const _screenFactor = 1.6;

    final _passwordValidator = MultiValidator([
      RequiredValidator(errorText: 'password is required'),
      MinLengthValidator(8,
          errorText: 'password must be at least 8 digits long'),
      PatternValidator(r'(?=.*?[#?!@$%^&*-])',
          errorText: 'passwords must have at least one special character')
    ]);

    final _usernameValidator = MultiValidator([
      RequiredValidator(errorText: 'username is required'),
      MinLengthValidator(2,
          errorText: 'username must be at least 2 digits long'),
      PatternValidator(
          r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
          errorText: 'invalid username')
    ]);

    final _usernameFormKey = GlobalKey<FormState>();
    final _nameFormKey = GlobalKey<FormState>();
    final _computerNameFormKey = GlobalKey<FormState>();
    final _passwordFormKey = GlobalKey<FormState>();
    final _confirmPasswordFormKey = GlobalKey<FormState>();

    var _passwordValidated = false;

    var password = '';

    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Who are you?'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width /
                                _screenFactor,
                            child: Form(
                              key: _nameFormKey,
                              child: TextFormField(
                                autofocus: true,
                                validator: RequiredValidator(
                                    errorText: 'name is required'),
                                autovalidateMode: AutovalidateMode.always,
                                controller: realNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Your name'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.check_circle,
                              color: yaru.Colors.green),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width /
                                _screenFactor,
                            child: Form(
                              key: _computerNameFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: computerNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Your Computers name'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.check_circle,
                              color: yaru.Colors.green),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width:
                            MediaQuery.of(context).size.width / _screenFactor,
                        child: Text(
                            'The name it uses when it talks to other computers.'),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width /
                                _screenFactor,
                            child: Form(
                              key: _usernameFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: usernameController,
                                validator: _usernameValidator,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pick a username'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.check_circle,
                              color: yaru.Colors.green),
                        )
                      ],
                    ),
                    loginStrategy == LoginStrategy.REQUIRE_PASSWORD
                        ? Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      _screenFactor,
                                  child: Form(
                                    key: _passwordFormKey,
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: _passwordValidator,
                                      onChanged: (val) {
                                        password = val;
                                        _passwordValidated = (null !=
                                                _passwordFormKey
                                                    .currentState) &&
                                            _passwordFormKey.currentState!
                                                .validate();
                                      },
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Choose a password'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return _passwordValidated
                                      ? Icon(Icons.check_circle,
                                          color: yaru.Colors.green)
                                      : Text('');
                                }),
                              )
                            ],
                          )
                        : Padding(padding: EdgeInsets.all(1)),
                    loginStrategy == LoginStrategy.REQUIRE_PASSWORD
                        ? Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      _screenFactor,
                                  child: Form(
                                    key: _confirmPasswordFormKey,
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: confirmPasswordController,
                                      validator: (val) => MatchValidator(
                                              errorText:
                                                  'passwords do not match')
                                          .validateMatch(val!, password),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Confirm your password'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: _confirmPasswordFormKey.currentState ==
                                            null ||
                                        !_confirmPasswordFormKey.currentState!
                                            .validate()
                                    ? null
                                    : Icon(Icons.check_circle,
                                        color: yaru.Colors.green),
                              )
                            ],
                          )
                        : Padding(padding: EdgeInsets.all(1)),
                    Row(
                      children: [
                        Radio<LoginStrategy>(
                            value: LoginStrategy.AUTO_LOGIN,
                            groupValue: loginStrategy,
                            onChanged: (_) => setState(() {
                                  loginStrategy = LoginStrategy.AUTO_LOGIN;
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
                            groupValue: loginStrategy,
                            onChanged: (_) => setState(() {
                                  loginStrategy =
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
                    if (_nameFormKey.currentState!.validate() &&
                        _computerNameFormKey.currentState!.validate() &&
                        _usernameFormKey.currentState!.validate() &&
                        _passwordFormKey.currentState!.validate() &&
                        _confirmPasswordFormKey.currentState!.validate()) {
                      final client =
                          Provider.of<SubiquityClient>(context, listen: false);

                      await client.setIdentity(IdentityData(
                          hostname: computerNameController.text,
                          realname: realNameController.text,
                          username: usernameController.text,
                          cryptedPassword: passwordController.text));

                      Navigator.pushNamed(context, Routes.chooseYourLook);
                    }
                  },
                ),
              ],
            ));
  }
}
