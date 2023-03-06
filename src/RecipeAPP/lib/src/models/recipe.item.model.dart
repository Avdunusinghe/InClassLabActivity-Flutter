import 'package:firebase_database/firebase_database.dart';

class RecipeItemModel {
  String id;
  String title;
  String description;
  String ingredients;

  RecipeItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
  });

  factory RecipeItemModel.fromMap(Map<String, dynamic> map) {
    return RecipeItemModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ingredients: map['ingredients'] ?? '',
    );
  }
}
