// file: lib/screens/recipe_item.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
// Chúng ta sẽ import màn hình chi tiết sau khi tạo ở Giai đoạn 3
// import 'recipe_detail_screen.dart';
import 'recipe_detail_screen.dart';
class RecipeItem extends StatelessWidget {
  final Recipe recipe;

  const RecipeItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Sử dụng Card để hiển thị đẹp hơn [cite: 9]
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        // Trong widget build của RecipeItem...
        onTap: () {
          // Sử dụng Navigator.push để chuyển màn hình
          Navigator.push(
            context,
            MaterialPageRoute(
              // Truyền đối tượng recipe sang màn hình chi tiết
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh món ăn (Bo góc trên)
            // Tìm đoạn ClipRRect chứa Image.network và thay bằng:
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Builder(
                builder: (context) {
                  // Nếu không có ảnh
                  if (recipe.imageUrl.isEmpty) {
                    return Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.restaurant, size: 50));
                  }
                  // Nếu là ảnh trong máy (Assets) - Lưu ý dùng dấu gạch chéo /
                  if (recipe.imageUrl.startsWith('assets/')) {
                    return Image.asset(
                      recipe.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey, child: const Icon(Icons.broken_image)),
                    );
                  }
                  // Nếu là ảnh mạng
                  return Image.network(
                    recipe.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey, child: const Icon(Icons.broken_image)),
                  );
                },
              ),
            ),
            // Thông tin tên và mô tả ngắn
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    recipe.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}