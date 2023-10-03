import 'package:event_app/screen/event/booked_event_screen.dart';
import 'package:event_app/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSidebar extends StatelessWidget {

  int i=1;

  Future<void> _handleLogout() async {
    // Clear the isLoggedIn value in SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigate to the login screen
    // Navigator.of(context).pushNamed('/');
  }

  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Your Name"),
            accountEmail: Text("your@email.com"),
            currentAccountPicture: CircleAvatar(
              // Your profile picture here
              backgroundImage: AssetImage('assets/profile_1.jpg'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigate to the home screen
              // HomeScreen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
              // Add your navigation logic here
            },
          ),
          // Add more ListTile widgets for other navigation options
          // ...
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text('Booked Event'),
            onTap: () {

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookedEventListScreen(),
              ));

              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => BookedEventListScreen(),
              //   ),
              // );
              // Navigate to the settings screen

              // Navigator.pop(context);

              // Add your navigation logic here
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: ()
              async {
                await _handleLogout();
                Navigator.of(context).pushNamed('/');
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.red,
                ),
                child: Center(child: const Text("Logout",style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
