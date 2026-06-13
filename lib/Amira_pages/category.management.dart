import 'package:flutter/material.dart';

// --- DATA MODEL ---
class CategoryModel {
  String id;
  String name;
  String icon;
  Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CategoryManagementPage extends StatefulWidget {
  final List<CategoryModel> categories;
  final Function(List<CategoryModel>) onCategoriesUpdated;
  final VoidCallback? onBack; // Tambah ini

  const CategoryManagementPage({
    super.key,
    required this.categories,
    required this.onCategoriesUpdated,
    this.onBack,
  });

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final Color bgColor = const Color(0xFFF3F4F6);
  final Color cardColor = Colors.white;
  final Color accentColor = const Color(0xFF8B5CF6);

  late List<CategoryModel> _categories;

  @override
  void initState() {
    super.initState();
    _categories = List<CategoryModel>.from(widget.categories);
  }

  void _showCategoryDialog({CategoryModel? editItem}) {
    final nameController = TextEditingController(text: editItem?.name ?? '');
    final iconController = TextEditingController(text: editItem?.icon ?? '📁');
    Color selectedColor = editItem?.color ?? Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(editItem == null ? 'Add Category' : 'Edit Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                  TextField(controller: iconController, decoration: const InputDecoration(labelText: 'Icon')),
                  const SizedBox(height: 20),
                  _buildColorPicker(selectedColor, (c) => setDialogState(() => selectedColor = c)),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    List<CategoryModel> updated = List<CategoryModel>.from(_categories);
                    if (editItem == null) {
                      updated.add(CategoryModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        icon: iconController.text,
                        color: selectedColor,
                      ));
                    } else {
                      final i = updated.indexWhere((c) => c.id == editItem.id);
                      updated[i] = CategoryModel(id: editItem.id, name: nameController.text, icon: iconController.text, color: selectedColor);
                    }
                    setState(() => _categories = updated);
                    widget.onCategoriesUpdated(updated);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // BUTANG BACK
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
        title: const Text('Category Management', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final item = _categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: Text(item.icon, style: const TextStyle(fontSize: 24)),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showCategoryDialog(editItem: item),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildColorPicker(Color current, Function(Color) onSelect) {
    final List<Color> colors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple];
    return Wrap(
      spacing: 10,
      children: colors.map((c) => GestureDetector(
        onTap: () => onSelect(c),
        child: Container(width: 30, height: 30, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: c == current ? Border.all(width: 3) : null)),
      )).toList(),
    );
  }
}
