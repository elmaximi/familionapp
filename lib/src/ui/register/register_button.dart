import 'package:familionapp/src/util/config.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: secondaryColor,
          ),
        ),
        onPressed: _onPressed,
      ),
      //child: Center(child: Text('Login')),
    );
  }
}
