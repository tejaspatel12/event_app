class EventCategory {
  final int id;
  final String name;
  final String imageUrl;
  final String description;

  EventCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  // Define a fromJson factory method to deserialize JSON data
  // factory EventCategory.fromJson(Map<String, dynamic> json) {
  //   return EventCategory(
  //     // id: json['id'] as int,
  //     // id: int.parse(json['id'] as String), // Convert the id to an integer
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //     imageUrl: json['imageUrl'] as String,
  //   );
  // }


  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: int.parse(json['id'] as String),
      name: json['name'] != null ? json['name'] as String : 'No Name',
      imageUrl: json['image_url'] != null ? json['image_url'] as String : '',
      description: json['description'] != null ? json['description'] as String : '',
    );
  }

}
