import 'dart:convert';
import 'package:event_app/model/slider_model.dart';
import 'package:http/http.dart' as http;

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

}
