import 'dart:convert';
import 'dart:js_interop';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_17/models/config.dart';
import 'package:flutter_application_17/models/users.dart';
import 'package:http/http.dart' as http;

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formkey = GlobalKey<FormState>();
  // Users user = Users();
  late Users user;

  Future<void> addNewUser(user) async {
    var url = Uri.http(configure.server, "users");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(user.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, 'refresh');
    }
  }

  Future<void> updateData(user) async {
    var url = Uri.http(configure.server, "users/${user.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      user = ModalRoute.of(context)!.settings.arguments as Users;
    } catch (e) {
      user = Users();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("User Form"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fnameInputField(),
                emailInputField(),
                passwordInputField(),
                genderFormInput(),
                SizedBox(
                  height: 10,
                ),
                submitButton(),
              ],
            )),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: user.fullname,
      decoration: InputDecoration(labelText: "Fullname", icon: Icon(Icons.person)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.fullname = newValue,
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: user.email,
      decoration: const InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an email';
        }
        if (!EmailValidator.validate(value)) {
          return 'Please enter a valid email';
        }
        return null; // ถ้าผ่านเงื่อนไขทั้งหมด
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: user.password,
      obscureText: true,
      decoration:
          const InputDecoration(labelText: "Password:", icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a password';
        }
        return null; // ถ้าผ่านเงื่อนไขทั้งหมด
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }

  Widget genderFormInput() {
    var initGen = "None";
    try {
      if (!user.gender!.isNull) {
        initGen = user.gender!;
      } 
    }catch (e) {
        initGen = "None";
    }
  
  return DropdownButtonFormField(
    value: initGen,
    decoration: InputDecoration(labelText: "Gender", icon: Icon(Icons.man)),
    items: configure.gender.map((String val) {
      return DropdownMenuItem(value: val, child: Text(val));
    }).toList(),
    onChanged: (value) {
      user.gender = value;
    },
    onSaved: (newValue) => user.gender = newValue,
  );
}


  Widget submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(user.toJson().toString());
            if (user.id == null) {
              addNewUser(user);
            } else {
              updateData(user);
            }
          }
        },
        child: Text("Save"));
  }
}
