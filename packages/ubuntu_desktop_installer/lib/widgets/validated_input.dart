import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

/// A [TextFormField] rewarding a validated input with a specific widget.
class ValidatedInput extends StatelessWidget {
  /// The key used to request validation before confirming the field values.
  final GlobalKey<FormState> formKey;

  /// The controller used to get the [TextField] values.
  final TextEditingController controller;

  /// The validator used to validate the [TextField] value.
  final FieldValidator<String?> validator;

  /// The label above the [TextField]
  final String label;

  /// This boolean is forwarded to the [TextField] to decide
  /// if the digits should be obscured.
  final bool obscureText;

  /// The specific widget shown right to the [TextField] if the
  /// input value is valid.
  final Widget successWidget;

  /// Creates a [TextFormField] and a check mark.
  ///
  /// The `validator' helps to decide when to show the check mark.
  ValidatedInput(
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
