// file: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../models/recipe.dart';
import 'recipe_item.dart';
import 'add_recipe_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công thức Nấu ăn (Online)'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
      ),
      // Sử dụng StreamBuilder để lắng nghe dữ liệu từ Collection 'recipes'
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          // 1. Trạng thái đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Trạng thái lỗi
          if (snapshot.hasError) {
            return const Center(child: Text('Lỗi tải dữ liệu!'));
          }

          // 3. Kiểm tra dữ liệu rỗng
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Chưa có công thức nào.'));
          }

          // 4. Lấy danh sách documents
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Lấy dữ liệu thô từ Firestore
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              // Chuyển đổi sang đối tượng Recipe dùng hàm fromMap vừa tạo
              final recipe = Recipe.fromMap(data, docId);

              // Hiển thị ra giao diện
              return RecipeItem(recipe: recipe);
            },
          );
        },
      ),
    );
  }
}