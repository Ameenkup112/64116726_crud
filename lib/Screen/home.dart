import 'package:flutter/material.dart';
import 'package:flutter_application_17/Screen/userform.dart';
import 'package:flutter_application_17/Screen/userinfo.dart';
import 'package:flutter_application_17/models/config.dart';
import 'package:flutter_application_17/models/users.dart';
import 'package:http/http.dart' as http;
import 'sidemenu.dart';

class Home extends StatefulWidget {
  static const routeName = "/";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget MainBody = Container();
  
@override
void initState() {
  super.initState();
  Users user = configure.login;
  if(user.id != null) {
    getUsers();
  }
}
    List<Users>_userList = [];
    Future<void> getUsers() async{
      var url = Uri.http(configure.server, "users");
      var resp = await http.get(url);
      setState(() {
              _userList = usersFromJson(resp.body);
              MainBody = showUsers();
      });
      return;
    }

    Future<void> removeUsers(user) async {
      var url = Uri.http(configure.server, "users/${user.id}");
      var res = await http.delete(url);
      print(res.body);
      _userList.remove(user);
      setState(() {});
      return;
    }

    Future<bool> showdeleteConfirmationDialog(user) async {
      return await showDialog(
        context: context,
        barrierDismissible:  false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this user?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Delete"),
              ),
              FilledButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const SideMenu(),
      body: MainBody,
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add),
        onPressed: () async { 
          String result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UserForm(),));
            if(result == "refresh") {
              getUsers();
            }
        },
      )    
    );
  }
  Widget showUsers(){
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        Users user = _userList[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) async {
            bool confirmed = await showdeleteConfirmationDialog(user);
            if (confirmed) {
              removeUsers(user);
            } else {
              // Reinsert the dismissed item back into the list
              setState(() {
                getUsers();
              });
            }
          },
          background: Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.grey),
          ),
          child: ListTile(
            title: Text("${user.fullname}"),
            subtitle: Text("${user.email}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInfo(),
                  settings: RouteSettings(arguments: user),
                ),
              );
            },
            trailing: IconButton(
              onPressed: () async {
                String result = await Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => const UserForm(),
                settings: RouteSettings(
                  arguments: user
                  )));
                if(result == "refresh"){
                  getUsers();
                }
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        );
      },
    );
  }
}


  
  