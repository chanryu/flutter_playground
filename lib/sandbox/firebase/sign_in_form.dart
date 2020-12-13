import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  final void Function(String, String) onSubmit;
  SignInForm({@required this.onSubmit}) : assert(onSubmit != null);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please a valid email.';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            controller: _passwordController,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topRight,
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.onSubmit(
                    _emailController.text,
                    _passwordController.text,
                  );
                }
              },
              child: Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
