// file: lib/models/recipe.dart
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
  });

  // --- Thêm mới hàm này để đọc dữ liệu từ Firebase ---
  factory Recipe.fromMap(Map<String, dynamic> data, String documentId) {
    return Recipe(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      // Xử lý an toàn cho mảng (List) từ Firebase
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
    );
  }
}