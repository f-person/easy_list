import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue = '';
  String _passwordValue = '';
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  setState(() {
                    _emailValue = value;
                  });
                }),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  _passwordValue = value;
                });
              },
            ),
            SwitchListTile(
              value: _acceptTerms,
              onChanged: (bool value) {
                setState(() {
                  _acceptTerms = value;
                });
              },
              title: Text('Accept Terms'),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text('Login'),
                  onPressed: () {
                    print(_emailValue);
                    print(_passwordValue);
                    Navigator.pushReplacementNamed(context, '/products');
                  }),
            )
          ],
        ),
      ),
    );
  }
}
