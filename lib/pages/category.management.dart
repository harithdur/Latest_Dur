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

  const CategoryManagementPage({
    super.key,
    required this.categories,
    required this.onCategoriesUpdated,
  });

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  // Theme Colors (Disesuaikan dengan tema Modern Clean anda)
  final Color bgColor = const Color(0xFFF3F4F6);
  final Color cardColor = Colors.white;
  final Color accentColor = const Color(0xFF8B5CF6);
  final Color textPrimary = const Color(0xFF111827);
  final Color textSecondary = const Color(0xFF6B7280);

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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                    TextField(controller: iconController, decoration: const InputDecoration(labelText: 'Icon (Emoji)')),
                    const SizedBox(height: 20),
                    _buildColorPicker(selectedColor, (c) => setDialogState(() => selectedColor = c)),
                  ],
                ),
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(), // Buka drawer utama
        ),
        title: Text('Category Management', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ALL CATEGORIES', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final item = _categories[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: Text(item.icon, style: const TextStyle(fontSize: 24)),
                      title: Text(item.name, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => _showCategoryDialog(editItem: item)),
                          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), 
                            onPressed: () {
                              List<CategoryModel> updated = List<CategoryModel>.from(_categories);
                              updated.removeWhere((c) => c.id == item.id);
                              setState(() => _categories = updated);
                              widget.onCategoriesUpdated(updated);
                            }
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildColorPicker(Color current, Function(Color) onSelect) {
    final List<Color> colors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.pink, Colors.teal];
    return Wrap(
      spacing: 10,
      children: colors.map((c) => GestureDetector(
        onTap: () => onSelect(c),
        child: Container(width: 30, height: 30, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: c == current ? Border.all(width: 3) : null)),
      )).toList(),
    );
  }
}
