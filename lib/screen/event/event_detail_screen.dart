import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api.dart';
import '../../model/event_model.dart';
import 'package:http/http.dart' as http;

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  DateTime now = DateTime.now();

  String userId = "";

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
    });
  }


  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> bookEvent(String eventId, String userId) async {
    final apiUrl = 'https://event.activeapp.in/event_booking.php'; // Replace with your API URL

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'eventId': eventId,
        'userId': userId,
      },
    );

    if (response.statusCode == 200) {
      // API call was successful, handle the response data if needed
      final responseData = json.decode(response.body);
      print("Done-----------------------");
      // You can do something with the responseData here
    } else {
      // API call failed, handle errors here
      print("NOT DONE-----------------------");
      throw Exception('Failed to book the event');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // appBar: AppBar(
      //   title: Text(widget.event.title),
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController, // Attach the scroll controller to the SingleChildScrollView
            // padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [




                            Container(
                              height: 320,
                              // color: Colors.red,
                            ),

                            Image.network(widget.event.imageUrl),

                            // Back button
                            Positioned(
                              top: 40, // Adjust the position as needed
                              left: 20, // Adjust the position as needed
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: Colors.white,
                              ),
                            ),

                            // Share button
                            Positioned(
                              top: 40, // Adjust the position as needed
                              right: 20, // Adjust the position as needed
                              child: IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  // Handle share button press here.
                                },
                                color: Colors.white,
                              ),
                            ),

                            // Text between buttons
                            const Positioned(
                              top: 50, // Adjust the position as needed
                              left: 100, // Adjust the position as needed
                              right: 100, // Adjust the position as needed
                              child: Center(
                                child: Text(
                                  "Event Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 10, // Adjust the position as needed
                              left: 50, // Adjust the position as needed
                              right: 50, // Adjust the position as needed
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                    color: Colors.white,
                                    // color: Colors.pink,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),


                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          children: [

                                            Positioned(
                                              top: 0,
                                              left: 60,
                                              child: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                                    color: Colors.white,
                                                    // color: Colors.pink,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: Image.asset('assets/profile_3.jpg',height: 40,)),
                                                  )
                                              ),
                                            ),

                                            Positioned(
                                              top: 0,
                                              left: 30,
                                              child: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                                    color: Colors.white,
                                                    // color: Colors.pink,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: Image.asset('assets/profile_2.jpg',height: 40,)),
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
                                                  child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: Image.asset('assets/profile_1.jpg',height: 40,)),
                                                )
                                            ),

                                            Container(
                                               width: 105,
                                            ),


                                          ],
                                        ),

                                        const Text(
                                          "+20 Going",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.blue,
                                              // color: Colors.pink,
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
                                              child: Text("Invite",style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400,),),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),



                        Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [


                                SizedBox(height: 25,),

                                Text(
                                  widget.event.title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                                ),

                                SizedBox(height: 25,),


                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.blue.shade50,
                                          // color: Colors.pink,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SvgPicture.asset('assets/icons/calendar.svg',height: 30,),
                                        )
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${widget.event.eventTime}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5,),
                                        const Text(
                                          'Tuesday, 4:00PM - 9:00PM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.blue.shade50,
                                          // color: Colors.pink,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SvgPicture.asset('assets/icons/maps.svg',height: 30,),
                                        )
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          widget.event.location, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          widget.event.location_full, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),


                                SizedBox(height: 20,),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(borderRadius: BorderRadius.circular(10.0),child: Image.asset('assets/profile_1.jpg',height: 50,)),

                                        SizedBox(width: 10,),
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Jay Patel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              'Organizer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.blue.shade50,
                                          // color: Colors.pink,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
                                          child: Text("Follow",style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w400,),),
                                        )
                                    ),
                                  ],
                                ),


                                SizedBox(height: 25,),

                                const Text(
                                  'About Event',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  widget.event.description,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,letterSpacing: 0.1,color: Colors.black54),
                                ),


                                const SizedBox(height: 100,),
                              ],
                            ),
                          ),
                        ),


                      ],
                    )
                ),


                // You can add more event details here
              ],
            ),
          ),

          // "Message" and "Call" buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // color: Colors.red, // Background color for the buttons
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.white, Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.1)]),
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Handle Message button tap
                  //   },
                  //   child: const Text('Message'),
                  // ),

                  GestureDetector(
                    onTap: () async {
                      try {
                        await EventApi(baseUrl: 'https://event.activeapp.in/').bookEvent(widget.event.id.toString(), userId);
                        // Handle success, e.g., show a success message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Event booked successfully'),
                        ));
                      } catch (e) {
                        // Handle error, e.g., show an error message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to book event'),
                        ));
                      }
                    },

                    // bookEvent(widget.event.id.toString(), '1');

                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Buy Ticket  ₹"+ '${widget.event.price}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



