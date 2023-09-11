import 'dart:ui';

import 'package:event_app/screen/event/event_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String Token="";

  List<String> locations = ['Location 1', 'Location 2', 'Location 3'];
  String selectedLocation = 'Location 1'; // Default selected location

  // late final EventApi eventApi;
  // late final EventApi eventApi = EventApi();
  final EventApi eventApi = EventApi(baseUrl: 'https://event.activeapp.in/');

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      setState(() {
        Token = token!;
        //print(isOffline);
      });
      // TODO: Save the token to your backend or use it for sending notifications
    });
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
      extendBodyBehindAppBar: true, // Enable the app bar to overlap the body
      // appBar: AppBar(title: Text('Home')),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the app bar transparent
        // backgroundColor: Colors.white, // Background color of the app bar
        elevation: 0, // Remove the shadow
        // titleSpacing: 0, // Remove title spacing
        title: const Row(
          children: [
            CircleAvatar(
              // User profile image
              radius: 20,
              backgroundImage: NetworkImage(
                // 'https://example.com/user_profile_image.jpg', // Replace with the user's profile image URL
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
            icon: Icon(Icons.notifications), // Notification button
            onPressed: () {
              // Handle notification button tap
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/bg.jpg'), // Replace with your background image
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color.fromARGB(255, 29, 221, 163)],
            ),
          ),),
          // Frosted glass-like overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.3), // Adjust opacity as needed
            ),
          ),
          // Frosted glass-like overlay
          SingleChildScrollView(
            child: Column(
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
                Expanded(
                  child: EventHList(eventApi: eventApi), // Pass the eventApi instance
                ),
              ],
            ),
          ),
        ],
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
            height: 100.0,
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
