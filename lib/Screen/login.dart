import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_17/Screen/home.dart';
import 'package:flutter_application_17/models/config.dart';
import 'package:flutter_application_17/models/users.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const routeName = "/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();
  // late Users user;

  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.password};
    var url = Uri.http(configure.server, "users", params);
    var resp = await http.get(url);
    print(resp.body);
    List<Users> login_result = usersFromJson(resp.body);
    print(login_result.length);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("username or password invalid")));
    } else {
      configure.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    // var user = ModalRoute.of(context)!.settings.arguments as Users;
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //textHeader(),
              emailInputField(),
              passwordInputField(),
              const SizedBox(height: 20),
              Center(
                  child: Column(
                children: [
                  submitButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  registerLink()
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: "ameen@gmail.com",
      decoration:
          const InputDecoration(labelText: "Email:", icon: Icon(Icons.email)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required ";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: "ameen123",
      obscureText: true,
      decoration:
          InputDecoration(labelText: "password", icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(user.toJson().toString());
          login(user);
        }
      },
      child: Text("Ligin"),
    );
  }

  Widget registerLink() {
    return TextButton(
      child: const Text("Sign Up"),
      onPressed: () async {
        String result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
        if (result == "refresh") {}
      },
    );
  }
}
