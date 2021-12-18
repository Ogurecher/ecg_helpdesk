import 'package:flutter/material.dart';

Widget messageField(GlobalKey<FormState> formKey, TextEditingController controller, Function sendMessage, Function pickFile) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Form(
      key: formKey,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              pickFile();
            },
            child: Icon(Icons.attach_file)
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Message'
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter message';
                }
              },
            ),
          ),
          TextButton(
            onPressed: () async {
              await sendMessage();

              controller.clear();
            },
            child: Icon(Icons.send)
          ),
        ],
      )
    ),
  );
}