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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const padding = 10.0;
    const screenFactor = 1.6;
    final successIcon = Icon(Icons.check_circle, color: yaru.Colors.green);
    final whoAreYouModel = Provider.of<WhoAreYouModel>(context, listen: true);

    return LocalizedView(builder: (context, lang) {
      Widget buildPasswordStrengthLabel(
        PasswordStrength? passwordStrength,
      ) {
        final weakPasswordLabel = lang.whoAreYouPagePasswordWeakPasswordLabel;
        final averagePasswordLabel =
            lang.whoAreYouPagePasswordAveragePasswordLabel;
        final strongPasswordLabel =
            lang.whoAreYouPagePasswordStrongPasswordLabel;

        switch (passwordStrength) {
          case PasswordStrength.weakPassword:
            return Text(weakPasswordLabel,
                style: TextStyle(
                  color: yaru.Colors.red,
                ));
          case PasswordStrength.averagePassword:
            return Text(averagePasswordLabel);
          case PasswordStrength.strongPassword:
            return Text(strongPasswordLabel,
                style: TextStyle(
                  color: yaru.Colors.green,
                ));
          default:
            return SizedBox.shrink();
        }
      }

      return WizardPage(
        title: Text(lang.whoAreYouPageTitle),
        content: SingleChildScrollView(
          child: Form(
            key: _whoAreYouFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: padding, bottom: padding),
                  child: ValidatedInput(
                    width: size.width / screenFactor,
                    spacing: padding,
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
                  padding: const EdgeInsets.only(top: padding, bottom: padding),
                  child: ValidatedInput(
                      width: size.width / screenFactor,
                      spacing: padding,
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
                    width: size.width / screenFactor,
                    child: Text(
                      lang.whoAreYouPageComputerNameInfo,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: padding, bottom: padding),
                  child: ValidatedInput(
                    width: size.width / screenFactor,
                    spacing: padding,
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
                    padding:
                        const EdgeInsets.only(top: padding, bottom: padding),
                    child: ValidatedInput(
                        width: size.width / screenFactor,
                        spacing: padding,
                        controller: _passwordController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: lang
                                  .whoAreYouPagePasswordRequiredValidatorErrorText),
                          MinLengthValidator(2,
                              errorText: lang
                                  .whoAreYouPagePasswordMinLengthValidatorErrorText),
                        ]),
                        label: lang.whoAreYouPagePasswordLabel,
                        obscureText: true,
                        successWidget: buildPasswordStrengthLabel(
                            whoAreYouModel.passwordStrength))),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: ValidatedInput(
                      width: size.width / screenFactor,
                      spacing: padding,
                      controller: _confirmPasswordController,
                      validator: _ConfirmPasswordValidator(
                          whoAreYouModel.password,
                          errorText: lang
                              .whoAreYouPageConfirmPasswordValidatorErrorText),
                      label: lang.whoAreYouPageConfirmPasswordLabel,
                      obscureText: true,
                      successWidget: successIcon),
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
                      child: Text(lang.whoAreYouPageLoginStrategyAutoLogin),
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
                      child:
                          Text(lang.whoAreYouPageLoginStrategyRequirePassword),
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
                await whoAreYouModel.saveIdentity();

                Navigator.pushNamed(context, Routes.chooseYourLook);
              }
            },
          ),
        ],
      );
    });
  }
}

class _ConfirmPasswordValidator extends FieldValidator<String?> {
  final String _password;

  _ConfirmPasswordValidator(this._password, {required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty == true && value == _password;
  }
}
