class SliderImage {
  final String id;
  final String imageUrl;

  SliderImage({
    required this.id,
    required this.imageUrl,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json) {
    return SliderImage(
      id: json['id'],
      imageUrl: json['imageUrl'],
    );
  }
}
