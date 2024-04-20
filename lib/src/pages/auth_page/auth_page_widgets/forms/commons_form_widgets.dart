import 'package:flutter/material.dart';

import 'package:taluxi_common/src/core/constants/colors.dart';
import 'package:taluxi_common/src/core/utils/form_fields_validators.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.title,
    super.key,
    this.fieldType,
    this.validator,
    this.maxLength,
    this.helperText,
    this.prefixIcon,
    this.onChange,
    this.suffixIcon,
    this.isPassword = false,
  });
  final String title;
  final bool isPassword;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChange;
  final TextInputType? fieldType;
  final int? maxLength;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            onChanged: onChange,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: maxLength,
            keyboardType: fieldType,
            validator: validator,
            onEditingComplete: node.nextFocus,
            obscureText: isPassword,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              labelText: title,
              prefixIcon: prefixIcon,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              helperText: helperText,
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.onChanged});
  final ValueChanged<String>? onChanged;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      onChange: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          isHiddenPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () => setState(() => isHiddenPassword = !isHiddenPassword),
      ),
      maxLength: 40,
      prefixIcon: const Icon(Icons.lock),
      title: 'Mot de passe',
      isPassword: isHiddenPassword,
      validator: passWordValidator,
    );
  }
}

class FormValidatorButton extends StatelessWidget {
  const FormValidatorButton({super.key, this.onClick, this.title = 'Valider'});
  final String title;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: mainLinearGradient,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

// const passWordField = CustomTextField(
//   maxLength: 40,
//   prefixIcon: Icon(Icons.lock),
//   title: "Mot de passe",
//   isPassword: true,
//   validator: passWordValidator,
// );
