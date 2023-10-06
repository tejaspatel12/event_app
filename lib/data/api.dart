import 'dart:convert';
import 'package:event_app/model/slider_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/booked_event_model.dart';
import '../model/event_category_model.dart';
import '../model/event_model.dart';

class EventApi {
  // static final EventApi _singleton = EventApi._internal();
  String baseUrl = "https://event.activeapp.in/";
  EventApi({required this.baseUrl});

  // factory EventApi() {
  //   return _singleton;
  // }

  // EventApi._internal();

  // final String _baseUrl = 'https://event.activeapp.in/'; // Define the base URL here

  Future<List<EventCategory>> fetchEventCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/get_categories.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((categoryJson) => EventCategory.fromJson(categoryJson)).toList();
    } else {
      throw Exception('Failed to fetch event categories');
    }
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/get_events.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((eventJson) => Event.fromJson(eventJson)).toList();
    } else {
      throw Exception('Failed to fetch events');
    }
  }

  Future<List<SliderImage>> fetchSliderImages() async {
    final response = await http.get(Uri.parse('$baseUrl/get_slider.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => SliderImage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load slider images');
    }
  }



  Future<void> bookEvent(String eventId, String userId) async {
    final url = Uri.parse('$baseUrl/event_booking.php'); // Replace with your actual API endpoint

    final response = await http.post(
      url,
      body: {
        'eventId': eventId,
        'userId': userId,
      },
    );

    if (response.statusCode == 200) {
      // Request was successful
      print('Event booked successfully');
    } else {
      // Request failed
      print('Failed to book event. Status code: ${response.statusCode}');
      throw Exception('Failed to book event');
    }
  }


  // Function to store user's mobile number and get user ID in response
  Future<void> storeUserMobileNumber(String mobileNumber) async {// Replace with your API URL
    final response = await http.post(Uri.parse('$baseUrl/login.php'), body: {'mobile_number': mobileNumber});
    if (response.statusCode == 200) {
      final userId = response.body; // Assuming the API returns the user ID
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);
    } else {
      // Handle API error
    }
  }


  // Future<List<Event>> fetchEvents() async {
  //   final response = await http.get(Uri.parse('$baseUrl/get_events.php'));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((eventJson) => Event.fromJson(eventJson)).toList();
  //   } else {
  //     throw Exception('Failed to fetch events');
  //   }
  // }


}
