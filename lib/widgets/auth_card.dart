import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  final _pw = FocusNode();
  final _pwConfir = FocusNode();

  bool _isLoading = false;
  bool _isObscure = true;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _swichObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _submit() {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    if (_authMode == AuthMode.Login) {
      // login
    } else {
      // Registrar
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pw.dispose();
    _pwConfir.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceZise = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        // height: _authMode == AuthMode.Login ? 310 : 370,
        height: 375,
        width: deviceZise.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              // EMAIL
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_pw);
                },
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Infome um e-mail válido!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              // SENHA
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                      icon: _isObscure
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: _swichObscure),
                ),
                controller: _passwordController,
                obscureText: _isObscure,
                keyboardType: TextInputType.emailAddress,
                textInputAction: _authMode == AuthMode.Signup
                    ? TextInputAction.next
                    : TextInputAction.done,
                focusNode: _pw,
                onFieldSubmitted: (_) {
                  _authMode == AuthMode.Signup
                      ? FocusScope.of(context).requestFocus(_pwConfir)
                      : _submit();
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    print(value);
                    return 'Infome uma senha válida!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              // CONFIRMACAO SENHA
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    suffixIcon: IconButton(
                        icon: _isObscure
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: _swichObscure),
                  ),
                  obscureText: _isObscure,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _pwConfir,
                  onFieldSubmitted: (_) {
                    _submit();
                  },
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Senhas são diferentes!';
                          } else if (value == '') {
                            return 'Repetir a Senha!';
                          }
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTRAR'),
                      onPressed: _submit,
                    ),
              FlatButton(
                child:
                    Text(_authMode == AuthMode.Login ? 'Registrar' : 'Login'),
                onPressed: _switchAuthMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
