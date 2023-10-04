class BookedEvent {
  final int eb_id;
  final DateTime bookingDate;
  final String title;
  final String imageUrl;
  final String location_full;
  final DateTime eventTime;

  BookedEvent({
    required this.eb_id,
    required this.bookingDate,
    required this.title,
    required this.imageUrl,
    required this.location_full,
    required this.eventTime,
  });

  factory BookedEvent.fromJson(Map<String, dynamic> json) {
    return BookedEvent(
      eb_id: int.parse(json['eb_id'] as String),
      imageUrl: json['image_url'] ?? '',
      location_full: json['location_full'] ?? 'No Location',
      title: json['title'] ?? 'No title',
      bookingDate: DateTime.parse(json['bookingDate'] ?? DateTime.now().toString()),
      eventTime: DateTime.parse(json['eventTime'] ?? DateTime.now().toString()),
    );
  }
}