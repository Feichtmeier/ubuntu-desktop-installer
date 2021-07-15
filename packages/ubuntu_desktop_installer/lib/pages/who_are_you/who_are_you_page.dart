import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:yaru/yaru.dart' as yaru;

import '../../routes.dart';
import '../../widgets/localized_view.dart';
import '../../widgets/validated_input.dart';
import '../wizard_page.dart';
import 'who_are_you_model.dart';

/// The installer page for setting up the user data.
///
/// It uses [WizardPage] and [WizardAction] to create an installer page.
class WhoAreYouPage extends StatefulWidget {
  /// Creates a the installer page for setting up the user data.
  const WhoAreYouPage({Key? key}) : super(key: key);

  ///
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          WhoAreYouModel(Provider.of<SubiquityClient>(context, listen: false)),
      child: WhoAreYouPage(),
    );
  }

  @override
  _WhoAreYouPageState createState() => _WhoAreYouPageState();
}

class _WhoAreYouPageState extends State<WhoAreYouPage> {
  final _realNameController = TextEditingController();
  final _computerNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _whoAreYouFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final whoAreYouModel = Provider.of<WhoAreYouModel>(context, listen: false);
    whoAreYouModel.loadIdentity().then((_) {
      _usernameController.text = whoAreYouModel.username;
    });

    _realNameController.addListener(() {
      whoAreYouModel.realName = _realNameController.text;
    });

    _computerNameController.addListener(() {
      whoAreYouModel.hostName = _computerNameController.text;
    });

    _usernameController.addListener(() {
      whoAreYouModel.username = _usernameController.text;
    });
    _passwordController.addListener(() {
      whoAreYouModel.password = _passwordController.text;
    });
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _computerNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            color: yaru.Colors.green,
          ));
    } else if (goodPatternPasswordValidator.isValid(value)) {
      return Text(averagePasswordLabel);
    }
    if (weakPasswordValidator.isValid(value)) {
      return Text(weakPasswordLabel,
          style: TextStyle(
            color: yaru.Colors.red,
          ));
    }

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    const screenFactor = 1.6;
    const checkMarksLeftPadding = 10.0;
    final successIcon = Icon(Icons.check_circle, color: yaru.Colors.green);

    final whoAreYouModel = Provider.of<WhoAreYouModel>(context, listen: true);

    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text(lang.whoAreYouPageTitle),
              content: SingleChildScrollView(
                child: Form(
                  key: _whoAreYouFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ValidatedInput(
                          width:
                              MediaQuery.of(context).size.width / screenFactor,
                          spacing: checkMarksLeftPadding,
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
                            width: MediaQuery.of(context).size.width /
                                screenFactor,
                            spacing: checkMarksLeftPadding,
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
                          width:
                              MediaQuery.of(context).size.width / screenFactor,
                          child: Text(
                            lang.whoAreYouPageComputerNameInfo,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ValidatedInput(
                          width:
                              MediaQuery.of(context).size.width / screenFactor,
                          spacing: checkMarksLeftPadding,
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
                            ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _confirmPasswordController,
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: checkMarksLeftPadding),
                                    child: value.text !=
                                                _passwordController.text ||
                                            !MultiValidator([
                                              RequiredValidator(
                                                  errorText: lang
                                                      .whoAreYouPagePasswordRequiredValidatorErrorText),
                                              MinLengthValidator(2,
                                                  errorText: lang
                                                      .whoAreYouPagePasswordMinLengthValidatorErrorText),
                                            ]).isValid(value.text)
                                        ? SizedBox.shrink()
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
                              groupValue: whoAreYouModel.loginStrategy,
                              onChanged: (_) => whoAreYouModel.loginStrategy =
                                  LoginStrategy.autoLogin),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text(lang.whoAreYouPageLoginStrategyAutoLogin),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<LoginStrategy>(
                              value: LoginStrategy.requirePassword,
                              groupValue: whoAreYouModel.loginStrategy,
                              onChanged: (_) => whoAreYouModel.loginStrategy =
                                  LoginStrategy.requirePassword),
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
                    if (_whoAreYouFormKey.currentState!.validate()) {
                      await whoAreYouModel.saveIdentify();

                      Navigator.pushNamed(context, Routes.chooseYourLook);
                    }
                  },
                ),
              ],
            ));
  }
}
