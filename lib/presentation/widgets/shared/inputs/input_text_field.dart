import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({
    super.key,
    required this.hintText,
    required this.textInputType,
    required this.textEditingController,
    this.isPass = false,
     this.onChanged,
     this.prefixIcon,
  });

  final String hintText;
  final TextInputType textInputType;
  final bool isPass;
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final Icon? prefixIcon;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Row( // Use Row for more control over layout (optional)
      children: [
        Expanded(
          child: TextField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPass // Conditionally show IconButton
                  ? IconButton(
                      icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    )
                  : null,
            ),
            keyboardType: widget.textInputType,
            obscureText: widget.isPass ? _showPassword : false,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
