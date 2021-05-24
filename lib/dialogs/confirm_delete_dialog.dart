import 'package:flutter/material.dart';

class ConfirmDialog extends AlertDialog {
  ConfirmDialog({
    ///то, что надо выполнить по нажатию на кнопку "ОК"
    @required func,
    @required textConfirm,
    @required text,

    ///надпись на кнопке "ОК"
    @required actionText,

    ///надпись на кнопке "отмена"
    @required cancelText,
    @required context,
  }) : super(
          title: Text(text),
          content: Text(textConfirm),
          actions: [
            ElevatedButton(
              onPressed: () {
                func();
                Navigator.of(context).pop();
              },
              child: Text(
                actionText,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(cancelText)),
          ],
        ) {}
}
