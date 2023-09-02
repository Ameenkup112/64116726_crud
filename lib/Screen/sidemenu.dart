import 'package:flutter/material.dart';
import 'package:flutter_application_17/Screen/home.dart';
import 'package:flutter_application_17/Screen/login.dart';
import 'package:flutter_application_17/models/config.dart';
import 'package:flutter_application_17/models/users.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName ="N/A";
    String accountEmail = "N/A";
    String accountUrl = "https://scontent-sin6-1.xx.fbcdn.net/v/t39.30808-6/273990598_270647851814953_2372274616391070599_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=5614bc&_nc_eui2=AeEOelNgCrVqofJ7SYWnQJk-jmp5_i9QCPiOann-L1AI-LPinEY_sB6QfQ0UJpK7nkbiy6ihDyABD1vz6DB98GQ8&_nc_ohc=AVOQ3cCFplIAX_y0DTq&_nc_ht=scontent-sin6-1.xx&oh=00_AfBge22D5VOqhHSjtyFvBmlrl_xXscB8QFIkCzFTryJztA&oe=64F47C0C";
    
    Users user = configure.login;
    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }
      return Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(accountName),
              accountEmail: Text(accountEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(accountUrl),  
              ),
              ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pushNamed(context, Home.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Login"),
              onTap: () {
                Navigator.pushNamed(context, Login.routeName);
              },
            )
          ],
        ),
      );
  }
}
