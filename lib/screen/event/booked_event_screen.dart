import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/booked_event_model.dart';

class BookedEventListScreen extends StatefulWidget {
  @override
  _BookedEventListScreenState createState() => _BookedEventListScreenState();
}

class _BookedEventListScreenState extends State<BookedEventListScreen> {
  // Define the API endpoint URL
  final String apiUrl = 'https://event.activeapp.in/get_booked_events.php'; // Replace with your API URL

  List<BookedEvent> bookedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  String userId = "";

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? ""; // Replace 'userId' with your actual key
    });
    // Make the API request using the user ID
    fetchBookedEvents(userId);
  }

  Future<void> fetchBookedEvents(String userId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        setState(() {
          Iterable list = json.decode(response.body);
          bookedEvents = list.map((model) => BookedEvent.fromJson(model)).toList();
        });
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load booked events');
      }
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }


  Future<void> cancelBooking(String bookingId) async {
    final url = Uri.parse('https://event.activeapp.in/cancel_booking.php/cancel_booking.php'); // Replace with your actual API endpoint

    final response = await http.post(
      url,
      body: {
        'booking_id': bookingId,
      },
    );

    if (response.statusCode == 200) {
      // Request was successful
        print('Booking canceled successfully');
    } else {
      // Request failed
        print('Failed to cancel booking. Status code: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchBookedEvents(userId);
        },
        child: ListView.builder(
          itemCount: bookedEvents.length,
          itemBuilder: (BuildContext context, int index) {
            // Customize the list item UI based on your API response structure
            return Padding(
              padding: const EdgeInsets.all(8.0),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                        child: Container(
                          width: 160, // Adjust the width and height to your preference
                          child: Image.network(
                            bookedEvents[index].imageUrl,
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bookedEvents[index].title ?? "",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                          SizedBox(height: 5,),

                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/maps.svg',height: 15,),
                              SizedBox(width: 5,),
                              Flexible(flex: 2, child: Text(bookedEvents[index].location_full?? "",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400))),
                            ],
                          ),

                          SizedBox(height: 5,),

                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/calendar.svg',height: 15,),
                              SizedBox(width: 5,),
                              Flexible(flex: 2, child: Text('${bookedEvents[index].eventTime}'?? "",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400))),
                            ],
                          ),

                          SizedBox(height: 5,),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  // print("Hiiiiiii ================== "+bookedEvents[index].eb_id.toString());
                                  cancelBooking(bookedEvents[index].eb_id.toString());
                                  // cancelBooking();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.red,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: Text("Cancel Booking",style: TextStyle(color: Colors.white,fontSize: 10),)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}