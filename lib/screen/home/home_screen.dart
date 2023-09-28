import 'dart:ui';

import 'package:event_app/screen/event/event_detail_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api.dart';
import '../../model/event_category_model.dart';
import '../../model/event_model.dart';
import '../../model/slider_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String Token="";
  late BuildContext _ctx;

  List<String> locations = ['Location 1', 'Location 2', 'Location 3'];
  String selectedLocation = 'Location 1'; // Default selected location

  // late final EventApi eventApi;
  // late final EventApi eventApi = EventApi();
  final EventApi eventApi = EventApi(baseUrl: 'https://event.activeapp.in/');

  @override
  void initState() {
    super.initState();
    // _firebaseMessaging.getToken().then((token) {
    //   print("FCM Token: $token");
    //   setState(() {
    //     Token = token!;
    //     //print(isOffline);
    //   });
    //   // TODO: Save the token to your backend or use it for sending notifications
    // });
  }


  VoidCallback _logoutCallback() {
    return () async {
      await _handleLogout();
    };
  }

  Future<void> _handleLogout() async {
    // Clear the isLoggedIn value in SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigate to the login screen
    Navigator.of(context).pushNamed('/');
    // Navigator.pushReplacement(
    //   context as BuildContext,
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      // Prevent navigating back to the previous screen
      return false;
    },
    child: Scaffold(
        // extendBodyBehindAppBar: true, // Enable the app bar to overlap the body
        // appBar: AppBar(title: Text('Home')),
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
          backgroundColor: Colors.transparent, // Make the app bar transparent
          elevation: 0, // Remove the shadow
          titleSpacing: 0, // Remove title spacing
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                // User profile image
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3387&q=80', // Replace with the user's profile image URL
                ),
              ),
              SizedBox(width: 8), // Add spacing between the profile image and user name
              Text(
                'John Doe', // User name
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black), // Notification button
              onPressed: () {
                // Handle notification button tap
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Event Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                EventCategoryList(eventApi: eventApi),// Pass the eventApi instance


                SliderImageList(sliderApi: eventApi),// Hide the slider if there are no images

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                EventHList(eventApi: eventApi),

                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: _logoutCallback(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue,
                      ),
                      child: Center(child: const Text("Logout",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
  );
  }
}



class EventCategoryList extends StatelessWidget {
  final EventApi eventApi;

  EventCategoryList({required this.eventApi}); // Receive the eventApi instance

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventCategory>>(
      future: eventApi.fetchEventCategories(), // Implement this method in your EventApi class
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final categories = snapshot.data!;
          return Container(
            height: 100.0,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0), // Add space between category items
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                        child: Container(
                          width: 60, // Adjust the width and height to your preference
                          height: 60,
                          child: Image.network(
                            category.imageUrl,
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                        ),
                      ),
                      Text(category.name ?? ""),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

class SliderImageList extends StatelessWidget {
  final EventApi sliderApi;

  SliderImageList({required this.sliderApi});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SliderImage>>(
      future: sliderApi.fetchSliderImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final images = snapshot.data!;
          return Container(
            // color: Colors.red,
            child: CarouselSlider(
              items: images.map((image) {
                return Image.network(image.imageUrl);
              }).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.3,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}


class EventHList extends StatelessWidget {
  final EventApi eventApi;

  EventHList({required this.eventApi}); // Receive the eventApi instance

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventApi.fetchEvents(), // Implement this method in your EventApi class
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final events = snapshot.data!;
          return Container(
            // color: Colors.blue,
            height: 220.0,
            child: ListView.builder(
              itemCount: events.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final event = events[index];

                final title = event.title ?? "No Title";
                final location = event.location ?? "No Location";
                final c = event.eventTime ?? "No Time";
                final price = event.price?.toStringAsFixed(2) ?? "No Price";
                final description = event.description ?? "No Description";

                return GestureDetector(
                  onTap: () {
                    // Navigate to the detail page when an event is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0), // Add space between category items
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                          child: Container(
                            width: 200, // Adjust the width and height to your preference
                            child: Image.network(
                              event.imageUrl,
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                        SizedBox(height: 4.00,),
                        Text(title ?? "",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                        SizedBox(height: 2.00,),
                        Text(location ?? "",style: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400)),

                        SizedBox(height: 2.00,),
                        Text("₹"+price ?? "",style: TextStyle(color: Colors.red,fontSize: 13,fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

class EventList extends StatelessWidget {
  final EventApi eventApi;

  EventList({required this.eventApi}); // Receive the eventApi instance

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventApi.fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              print("////////////////////////////////////////////////////////////");
              print("Title: ${event.title}");
              print("IMAGE: ${event.imageUrl}");

              final title = event.title ?? "No Title";
              final location = event.location ?? "No Location";
              final eventTime = event.eventTime ?? "No Time";
              final price = event.price?.toStringAsFixed(2) ?? "No Price";
              final description = event.description ?? "No Description";

              return ListTile(
                // leading: Image.network(event.imageUrl ?? ""),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                  child: Container(
                    width: 120, // Adjust the width and height to your preference
                    child: Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ),
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location: $location'),
                    Text('Time: $eventTime'),
                    Text('Price: \$$price'),
                  ],
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
