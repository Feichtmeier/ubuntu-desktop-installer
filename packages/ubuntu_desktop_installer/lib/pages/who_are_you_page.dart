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
  late LoginStrategy _loginStrategy;
  late TextEditingController _realNameController;
  late TextEditingController _computerNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _realNameController = TextEditingController();
    _computerNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _loginStrategy = LoginStrategy.REQUIRE_PASSWORD;
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

    final _computerNameValidator = PatternValidator(
        r'(?!-)[A-Z\d-]{1,63}(?<!-)$',
        errorText: 'Invalid computer name');

    final _usernameValidator = MultiValidator([
      RequiredValidator(errorText: 'username is required'),
      MinLengthValidator(2,
          errorText: 'username must be at least 2 digits long'),
      PatternValidator(
          r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
          errorText: 'invalid username')
    ]);

    final _realNameValidator = RequiredValidator(errorText: 'name is required');

    final _usernameFormKey = GlobalKey<FormState>();
    final _nameFormKey = GlobalKey<FormState>();
    final _computerNameFormKey = GlobalKey<FormState>();
    final _passwordFormKey = GlobalKey<FormState>();
    final _confirmPasswordFormKey = GlobalKey<FormState>();

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
                                validator: _realNameValidator,
                                autovalidateMode: AutovalidateMode.always,
                                controller: _realNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Your name'),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _realNameController,
                            builder: (context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: !_realNameValidator.isValid(value.text)
                                    ? Text('')
                                    : Icon(Icons.check_circle,
                                        color: yaru.Colors.green),
                              );
                            })
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
                                controller: _computerNameController,
                                validator: _computerNameValidator,
                                decoration: InputDecoration(
                                    suffix: Text(
                                      'The name it uses when it talks to other computers.',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Your Computers name'),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _computerNameController,
                            builder: (context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
                                    !_computerNameValidator.isValid(value.text)
                                        ? Text('')
                                        : Icon(Icons.check_circle,
                                            color: yaru.Colors.green),
                              );
                            })
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
                              key: _usernameFormKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _usernameController,
                                validator: _usernameValidator,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pick a username'),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _usernameController,
                            builder: (context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: !_usernameValidator.isValid(value.text)
                                    ? Text('')
                                    : Icon(Icons.check_circle,
                                        color: yaru.Colors.green),
                              );
                            })
                      ],
                    ),
                    _loginStrategy == LoginStrategy.REQUIRE_PASSWORD
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
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _passwordController,
                                  builder: (context, value, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: !_passwordValidator
                                              .isValid(value.text)
                                          ? Text('')
                                          : Icon(Icons.check_circle,
                                              color: yaru.Colors.green),
                                    );
                                  }),
                            ],
                          )
                        : Padding(padding: EdgeInsets.all(1)),
                    _loginStrategy == LoginStrategy.REQUIRE_PASSWORD
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
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: _confirmPasswordController,
                                      validator: (val) {
                                        return MatchValidator(
                                                errorText:
                                                    'passwords do not match')
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
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _confirmPasswordController,
                                  builder: (context, value, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child:
                                          value.text != _passwordController.text
                                              ? Text('')
                                              : Icon(Icons.check_circle,
                                                  color: yaru.Colors.green),
                                    );
                                  })
                            ],
                          )
                        : Padding(padding: EdgeInsets.all(1)),
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
                    if (_nameFormKey.currentState!.validate() &&
                        _computerNameFormKey.currentState!.validate() &&
                        _usernameFormKey.currentState!.validate() &&
                        _passwordFormKey.currentState!.validate() &&
                        _confirmPasswordFormKey.currentState!.validate()) {
                      // final client =
                      //     Provider.of<SubiquityClient>(context, listen: false);

                      // await client.setIdentity(IdentityData(
                      //     hostname: computerNameController.text,
                      //     realname: realNameController.text,
                      //     username: usernameController.text,
                      //     cryptedPassword: passwordController.text));

                      Navigator.pushNamed(context, Routes.chooseYourLook);
                    }
                  },
                ),
              ],
            ));
  }
}
