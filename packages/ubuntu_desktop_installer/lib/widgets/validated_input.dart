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

  /// Sets the optional width for layout reasons.
  final double? width;

  /// Sets the optional space between the [TextField] and the successWidget
  final double? spacing;

  /// Creates a [TextFormField] and a check mark.
  ///
  /// The `validator' helps to decide when to show the check mark.
  ValidatedInput({
    Key? key,
    required this.formKey,
    required this.controller,
    required this.validator,
    required this.label,
    required this.obscureText,
    required this.successWidget,
    this.spacing,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: width,
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
                  padding: EdgeInsets.only(left: spacing ?? 0.0),
                  child: !validator.isValid(value.text)
                      ? SizedBox.shrink()
                      : successWidget);
            })
      ],
    );
  }
}
