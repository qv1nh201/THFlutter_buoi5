// file: lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  // Nhận dữ liệu công thức qua constructor
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar có nút back tự động
      // Trong build của RecipeDetailScreen...
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          // Nút xóa
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Hiển thị hộp thoại xác nhận
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xác nhận xóa'),
                  content: Text('Bạn có chắc muốn xóa món "${recipe.title}" không?'),
                  actions: [
                    TextButton(
                      child: const Text('Hủy'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        // 1. Đóng hộp thoại
                        Navigator.of(ctx).pop();

                        // 2. Thực hiện xóa trên Firestore
                        try {
                          await FirebaseFirestore.instance
                              .collection('recipes')
                              .doc(recipe.id) // Dùng ID để xóa đúng document
                              .delete();

                          // 3. Quay về màn hình danh sách
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã xóa món ăn')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi xóa: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // Dùng SingleChildScrollView để cuộn được khi nội dung dài
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh lớn đầu trang
            // Tìm widget Image.network đầu tiên trong Column và thay bằng:
            Builder(
              builder: (context) {
                if (recipe.imageUrl.isEmpty) {
                  return Container(height: 250, color: Colors.grey[300], child: const Icon(Icons.restaurant, size: 60));
                }
                if (recipe.imageUrl.startsWith('assets/')) {
                  return Image.asset(
                    recipe.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 250, color: Colors.grey, child: const Icon(Icons.broken_image)),
                  );
                }
                return Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 250, color: Colors.grey, child: const Icon(Icons.broken_image)),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Tiêu đề món ăn
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 10),

                  // 3. Phần Nguyên liệu
                  const Text(
                    'Nguyên liệu:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Duyệt danh sách nguyên liệu để hiển thị
                  ...recipe.ingredients.map((ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ingredient, style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                  )),

                  const SizedBox(height: 20),

                  // 4. Phần Cách làm (Các bước)
                  const Text(
                    'Cách làm:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Duyệt danh sách các bước để hiển thị
                  ...recipe.steps.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    String step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.orange[100],
                            child: Text('$index', style: const TextStyle(fontSize: 12, color: Colors.orange)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(step, style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}