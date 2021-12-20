import 'package:flutter/material.dart';

FloatingActionButton createFloatingButton(BuildContext context, GlobalKey<FormState> formKey, TextEditingController formController, Function onCreateFunction) {
  return FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create new'),
            content: Form(
              key: formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'name',
                ),
                controller: formController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                },
              )
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await onCreateFunction();

                    formController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Confirm')
              ),
            ],
          );
        }
      );
    },
  );
}
