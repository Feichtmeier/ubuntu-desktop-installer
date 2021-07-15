import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

/// A [TextFormField] rewarding a validated input with a specific widget.
class ValidatedInput extends StatefulWidget {
  /// The controller used to get the [TextField] values. If [controller] is
  /// null, a controller is created internally and its text is set to
  /// [initialValue].
  final TextEditingController? controller;

  /// An optional value to initialize the form field with when not using a
  /// [controller].
  final String? initialValue;

  /// Called when the user changes the text in the field.
  final ValueChanged<String>? onChanged;

  /// The validator used to validate the [TextField] value.
  final FieldValidator<String?> validator;

  /// The label above the [TextField]
  final String? labelText;

  /// This boolean is forwarded to the [TextField] to decide
  /// if the digits should be obscured.
  final bool obscureText;

  /// The specific widget shown right to the [TextField] if the
  /// input value is valid.
  final Widget? successWidget;

  /// Sets the optional width for layout reasons.
  final double? width;

  /// Sets the optional space between the [TextField] and the successWidget
  final double? spacing;

  /// Creates a [TextFormField] and a check mark.
  ///
  /// The `validator' helps to decide when to show the check mark.
  ValidatedInput({
    Key? key,
    this.controller,
    this.initialValue,
    this.onChanged,
    required this.validator,
    this.labelText,
    this.obscureText = false,
    this.successWidget,
    this.spacing,
    this.width,
  }) : super(key: key);

  @override
  State<ValidatedInput> createState() => _ValidatedInputState();
}

class _ValidatedInputState extends State<ValidatedInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.width,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _controller,
            onChanged: widget.onChanged,
            validator: widget.validator,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: widget.labelText),
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Padding(
                  padding: EdgeInsets.only(left: widget.spacing ?? 0.0),
                  child: !widget.validator.isValid(value.text)
                      ? SizedBox.shrink()
                      : widget.successWidget);
            })
      ],
    );
  }
}
