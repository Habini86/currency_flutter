import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFieldText extends StatelessWidget {
  const CustomFieldText(
      {super.key,
      required this.labelText,
      required this.prefixText,
      required this.controllerText,
      required this.onChagedFunction});

  final ValueChanged<String> onChagedFunction;
  final String labelText;
  final String prefixText;
  final TextEditingController controllerText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controllerText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.amber,
        ),
        border: const OutlineInputBorder(),
        prefixText: "$prefixText ",
        prefixStyle: const TextStyle(
          color: Colors.amber,
          fontSize: 25.0,
        ),
      ),
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 25.0,
      ),
      onChanged: onChagedFunction,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}')),
      // ],
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            String newText = newValue.text.replaceFirst(RegExp(r'^0'), '');
            return newValue.copyWith(
              text: newText,
              selection: TextSelection.collapsed(offset: newText.length),
            );
          },
        ),
      ],
    );
  }
}
