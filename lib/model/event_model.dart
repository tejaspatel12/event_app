class Event {
  final int id;
  final String title;
  final String imageUrl;
  final String location;
  final String location_full;
  final DateTime eventTime;
  final String description;
  final double price;

  Event({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.location_full,
    required this.eventTime,
    required this.description,
    required this.price,
  });

  // Define a fromJson factory method to deserialize JSON data
  // factory Event.fromJson(Map<String, dynamic> json) {
  //   return Event(
  //     // id: json['id'] as int,
  //     id: int.parse(json['id'] as String), // Convert the id to an integer
  //     title: json['title'] as String,
  //     imageUrl: json['imageUrl'] as String,
  //     location: json['location'] as String,
  //     eventTime: DateTime.parse(json['eventTime'] as String),
  //     description: json['description'] as String,
  //     price: (json['price'] as num).toDouble(),
  //   );
  // }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id'] as String),
      title: json['title'] != null ? json['title'] as String : 'No Title',
      location: json['location'] != null ? json['location'] as String : 'No Location',
      location_full: json['location_full'] != null ? json['location_full'] as String : 'No Location',
      // eventTime: json['eventTime'] != null ? json['eventTime'] as String : 'No Time',
      eventTime: json['eventTime'] != null ? DateTime.parse(json['eventTime'] as String) // Parse the string to DateTime
          : DateTime.now(), // Provide a default DateTime if null
      // price: json['price'] != null ? json['price'].toDouble() as double : 0.0,
      price: json['price'] != null ? double.parse(json['price'] as String) : 0.0, // Use double.parse
      description: json['description'] != null ? json['description'] as String : 'No Description',
      // imageUrl: json['imageUrl'] != null ? json['imageUrl'] as String : '',
      imageUrl: json['image_url'] != null ? json['image_url'] as String : '',
    );
  }
}
