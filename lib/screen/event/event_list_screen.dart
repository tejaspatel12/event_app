import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/event_model.dart';


class EventListScreen extends StatefulWidget {
  final int categoryId; // Receive category ID from home screen

  EventListScreen({required this.categoryId});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents(widget.categoryId);
  }

  Future<void> fetchEvents(int categoryId) async {
    final response = await http.get(Uri.parse('https://event.activeapp.in/get_category_event.php/category_id/$categoryId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        // events = data.map((eventJson) => Event.fromJson(eventJson)).toList();
        Iterable list = json.decode(response.body);
        events = list.map((model) => Event.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to fetch events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            // title: Text(event.name),
            title: Text(events[index].title),
          );
        },
      ),
    );
  }
}