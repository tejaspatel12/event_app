import 'package:flutter/material.dart';

import '../../model/event_category_model.dart';

class CategoryDetailScreen extends StatelessWidget {
  final EventCategory category;

  CategoryDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Column(
        children: [
          Image.network(category.imageUrl),
          Text(category.name),
        ],
      ),
    );
  }
}
