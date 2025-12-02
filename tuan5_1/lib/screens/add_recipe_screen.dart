// file: lib/screens/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Khởi tạo các controller để quản lý dữ liệu nhập vào
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveRecipe() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên món')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Xử lý chuỗi nhập vào thành mảng (List) dựa trên dấu phẩy
      List<String> ingredientsList = _ingredientsController.text.split(',').map((e) => e.trim()).toList();
      List<String> stepsList = _stepsController.text.split(',').map((e) => e.trim()).toList();

      // Đẩy dữ liệu lên Firestore
      await FirebaseFirestore.instance.collection('recipes').add({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'imageUrl': _imageController.text.trim(),
        'ingredients': ingredientsList,
        'steps': stepsList,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm món thành công!')));
        Navigator.pop(context); // Quay về màn hình chính
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Món Mới')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tên món ăn', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Mô tả ngắn', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                  labelText: 'Link Ảnh (URL hoặc assets/...)',
                  border: OutlineInputBorder(),
                  hintText: 'VD: assets/images/mon_ngon.jpg'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                  labelText: 'Nguyên liệu (phân cách bằng dấu phẩy)',
                  border: OutlineInputBorder(),
                  hintText: 'VD: Trứng, Sữa, Bột mì'
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _stepsController,
              decoration: const InputDecoration(
                  labelText: 'Các bước làm (phân cách bằng dấu phẩy)',
                  border: OutlineInputBorder(),
                  hintText: 'VD: Bước 1 đun nước, Bước 2 thả mỳ'
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveRecipe,
                icon: const Icon(Icons.save),
                label: const Text('Lưu Công Thức'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}