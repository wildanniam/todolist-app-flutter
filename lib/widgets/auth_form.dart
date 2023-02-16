import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitAuthFormfn});

  final Function(
      {required String email,
      required String username,
      required String password,
      required bool isLogin}) submitAuthFormfn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  void submitForm() {
    if (_formKey != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print('_email $_email');
        print('_password: $_password');
        widget.submitAuthFormfn(
            email: _email,
            username: _username,
            password: _password,
            isLogin: _isLogin);
      }
    }
  }

  String _email = '';
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: Key('email'),
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@'))
                  return 'Masukkan Format Email yang Benar';
                return null;
              },
              onSaved: (value) {
                _email = value ?? '';
              },
            ),
            SizedBox(
              height: 15,
            ),
            if (!_isLogin)
              TextFormField(
                key: Key('username'),
                decoration: InputDecoration(
                    labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4)
                    return 'Username minimal memiliki 4 karakter';
                  return null;
                },
                onSaved: (value) {
                  _username = value ?? '';
                },
              ),
            if (!_isLogin)
              SizedBox(
                height: 15,
              ),
            TextFormField(
              key: Key('password'),
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 4)
                  return 'Password minimal memiliki 6 karakter';
                return null;
              },
              onSaved: (value) {
                _password = value ?? '';
              },
            ),
            SizedBox(
                height: 15,
              ),
            ElevatedButton(
                onPressed: submitForm,
                child: Text(_isLogin ? 'Masuk' : 'Daftar')),
            TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? 'Daftar akun baru' : 'Sudah punya akun'))
          ],
        ));
  }
}
