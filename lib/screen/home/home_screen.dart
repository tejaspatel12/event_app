import 'dart:ui';

import 'package:event_app/screen/event/event_detail_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import '../../Drawer.dart';
import '../../data/api.dart';
import '../../model/event_category_model.dart';
import '../../model/event_model.dart';
import '../../model/slider_model.dart';
import '../category/category_detail_screen.dart';
import '../event/booked_event_screen.dart';
import '../event/event_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String Token="";
  late BuildContext _ctx;

  List<String> locations = ['Location 1', 'Location 2', 'Location 3'];
  String selectedLocation = 'Location 1'; // Default selected location

  // late final EventApi eventApi;
  // late final EventApi eventApi = EventApi();
  final EventApi eventApi = EventApi(baseUrl: 'https://event.activeapp.in/');

  String userId = "";

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? ""; // Replace 'userId' with your actual key
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
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
  return Scaffold(
    key: _scaffoldKey,
    backgroundColor: Color(0xFFF3F0F0),
      // extendBodyBehindAppBar: true, // Enable the app bar to overlap the body
      appBar: AppBar(title: Text('Home')),

      // drawer: CustomSidebar(), // Add your custom sidebar here
      // drawer: CustomSidebar(), // Add your custom sidebar here

      drawer: CustomSidebar(), // Add your custom sidebar here
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Padding(
              //   padding: EdgeInsets.all(15.0),
              //   child: Text(
              //     'Event Categories',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),
              SizedBox(height: 20,),
              EventCategoryList(eventApi: eventApi),// Pass the eventApi instance

              SizedBox(height: 20,),

              SliderImageList(sliderApi: eventApi),// Hide the slider if there are no images


              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Upcoming Events',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              EventHList(eventApi: eventApi),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue.shade50,
                        // color: Colors.pink,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Invite your friends',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            Text('Get 20 for ticket',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400)),
                            Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.red,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                                    child: Center(child: Text("Invite",style: TextStyle(color: Colors.white,fontSize: 12),)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(right: 0,bottom: -20, child: Image.asset('assets/invite.png', height: 120,))
                  ],
                ),
              )
            ],
          ),
          Text(userId,style: TextStyle(fontSize: 100),),
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
            // color: Colors.pink,
            height: 50.0,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0), // Add space between category items
                  child: GestureDetector(
                    onTap: ()
                    {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EventListScreen(categoryId: category),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(category: categories[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        // color: Color(F007393B3),
                        color: Colors.blue
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              child: Container(
                                width: 40, // Adjust the width and height to your preference
                                height: 40,
                                color: Colors.blue.shade50,
                                // color: Color(0xffbad9d8),
                                child: Image.network(
                                  category.imageUrl,
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(category.name ?? "",style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
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
                return ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(image.imageUrl));
              }).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.24,
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              // color: Colors.blue,
              height: 240.0,
              child: ListView.builder(
                itemCount: events.length,
                scrollDirection: Axis.horizontal,
                // scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final event = events[index];

                  final title = event.title ?? "No Title";
                  final location = event.location_full ?? "No Location";
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
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          // color: Colors.purple,
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                child: Container(
                                  width: 200, // Adjust the width and height to your preference
                                  child: Image.network(
                                    event.imageUrl,
                                    fit: BoxFit.cover, // Adjust the fit as needed
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 4.00,),
                                  Text(title ?? "",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                                  SizedBox(height: 4.00,),

                                  Row(
                                    children: [
                                      Stack(
                                        children: [

                                          Positioned(
                                            top: 0,
                                            left: 50,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                                  color: Colors.white,
                                                  // color: Colors.pink,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: Image.asset('assets/profile_3.jpg',height: 30,)),
                                                )
                                            ),
                                          ),

                                          Positioned(
                                            top: 0,
                                            left: 25,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                                  color: Colors.white,
                                                  // color: Colors.pink,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: Image.asset('assets/profile_2.jpg',height: 30,)),
                                                )
                                            ),
                                          ),
                                          Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                                color: Colors.white,
                                                // color: Colors.pink,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: Image.asset('assets/profile_1.jpg',height: 30,)),
                                              )
                                          ),

                                          Container(
                                            width: 90,
                                          ),


                                        ],
                                      ),
                                      const Text(
                                        "+20 Going",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 4.00,),
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/maps.svg',height: 15,),
                                      SizedBox(width: 5,),
                                      Flexible(flex: 2, child: Text(location?? "",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400))),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
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
