import 'package:flutter/material.dart';
import 'package:to_do_list/util/my_button.dart';

// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 120,
        child: Column(children: [
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Type Something',
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: "Save",
                onPressed: onSave,
              ),
              const SizedBox(width: 10),
              MyButton(
                text: "Cancel",
                onPressed: onCancel,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
