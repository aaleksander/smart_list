import 'package:flutter/material.dart';

class InputTextDialog extends SimpleDialog {
  static TextEditingController _controller = TextEditingController();
  InputTextDialog(
      {@required func,
      @required textConfirm,
      @required text,
      @required context})
      : super(
          children: [
            TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: text,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  func(_controller.text);
                },
                child: Text(textConfirm),
              ),
            ),
          ],
        ) {
    _controller.text = '';
  }
}
