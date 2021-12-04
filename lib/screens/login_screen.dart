import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_route_mobile/components/loader_component.dart';
import 'package:pet_route_mobile/helpers/constans.dart';
import 'package:pet_route_mobile/models/token.dart';
import 'package:pet_route_mobile/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _emailError = "";
  bool _emailShowError = false;

  String _password = "";
  String _passwordError = "";
  bool _passwordShowError = false;

  bool _showPasswords = false;

  bool _rememberMe = true;

  bool _showLoader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _showLogo(),
                SizedBox(
                  height: 10,
                ),
                _showEmail(),
                _showPassword(),
                _showRememberMe(),
                SizedBox(
                  height: 10,
                ),
                _showButton(),
                _showGoogle(),
              ],
            ),
          ),
        ),
        _showLoader
            ? loaderComponents(
                text: 'Por favor espere',
              )
            : Container(),
      ],
    ));
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/logo.png'),
      width: 250,
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa tu email',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          prefixIcon: Icon(Icons.alternate_email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        obscureText: !_showPasswords,
        decoration: InputDecoration(
          hintText: 'Ingresa tu contraseña',
          labelText: 'Contraseña',
          errorText: _passwordShowError ? _passwordError : null,
          suffixIcon: IconButton(
            icon: _showPasswords
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showPasswords = !_showPasswords;
              });
            },
          ),
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showRememberMe() {
    return CheckboxListTile(
      title: Text('Recordarme'),
      value: _rememberMe,
      onChanged: (value) {
        setState(() {
          _rememberMe = value!;
        });
      },
    );
  }

  Widget _showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
            child: Text('Iniciar sesión'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Color(0xFF9347);
              }),
            ),
            onPressed: () => _login()),
        ElevatedButton(
            child: Text('Registrar'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Color(0xFF9347);
              }),
            ),
            onPressed: () {})
      ],
    );
  }

  Widget _showGoogle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
            child: Text('Iniciar con google'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Color(0xFF9347);
              }),
            ),
            onPressed: () => _googleLogin()),
      ],
    );
  }

  void _login() async {
    setState(() {
      _showPasswords = false;
    });
    if (!_validateFieds()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    var cocnectcityResult = await Connectivity().checkConnectivity();

    if (cocnectcityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica tu conexiín a internet',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ],
      );
      return;
    }
    setState(() {
      _showLoader = false;
    });

    Map<String, dynamic> request = {'userName': _email, 'password': _password};
    var url = Uri.parse('${Constans.apiUrl}/api/Account/CreateToken');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = "Email o contraseña incorrecta";
      });
      return;
    }
    setState(() {
      _showLoader = false;
    });

    var body = response.body;

    if (_rememberMe) {
      _storeUser(body);
    }

    var decodejson = jsonDecode(body);
    var token = Token.fromJson(decodejson);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
    );
  }

  bool _validateFieds() {
    bool isValidate = true;

    if (_email.isEmpty) {
      isValidate = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu email';
    } else if (!EmailValidator.validate(_email)) {
      isValidate = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email valido';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValidate = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu contraseña';
    } else if (_password.length < 6) {
      isValidate = false;
      _passwordShowError = true;
      _passwordError =
          'Debes ingresar una contraseña de al menos 6 carácteres ';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValidate;
  }

  void _storeUser(String body) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('IsRemembered', true);
    await pref.setString('userBody', body);
  }

  _googleLogin() async {
    var googleSign = GoogleSignIn();
    await googleSign.signOut();
    var user = await googleSign.signIn();
    print(user);

    Map<String, dynamic> request = {
      'email': user?.email,
      'id': user?.id,
      'logerType': 1,
      'fullName': user?.displayName,
      'photoURL': user?.photoUrl,
    };
    await _socialLogin(request);
  }

  Future _socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Account/SocialLogin');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
      });
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'El usuario ya inicio previamente con otra red social',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ],
      );
      print(response.statusCode);
      return;
    }
    setState(() {
      _showLoader = false;
    });

    var body = response.body;

    if (_rememberMe) {
      _storeUser(body);
    }

    var decodejson = jsonDecode(body);
    var token = Token.fromJson(decodejson);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
    );
  }
}
