import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/models/category.dart';
import 'expenses/expense_type_helpers.dart';

class CategoryPickerModal extends StatefulWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel> onCategorySelected;

  const CategoryPickerModal({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryPickerModal> createState() => _CategoryPickerModalState();
}

class _CategoryPickerModalState extends State<CategoryPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = widget.categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredCategories = widget.categories;
      } else {
        _filteredCategories = widget.categories
            .where((cat) =>
            cat.name.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plain Search Field
          TextField(
            controller: _searchController,
            onChanged: _filterCategories,
            decoration: InputDecoration(
              hintText: 'Cerca categoria...',
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () {
                  _searchController.clear();
                  _filterCategories('');
                },
              )
                  : null,
            ),
          ),
          const SizedBox(height: 24),

          // Raw List
          Expanded(
            child: _filteredCategories.isEmpty
                ? const Center(child: Text('Nessuna categoria trovata'))
                : ListView.builder(
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                final category = _filteredCategories[index];
                final isSelected =
                    widget.selectedCategory?.id == category.id;
                final catColor =
                Color(int.parse(category.color, radix: 16));

                return ListTile(
                  leading: Icon(
                    getIconFromName(category.icon),
                    color: catColor,
                  ),
                  title: Text(category.name),
                  trailing: isSelected
                      ? const Icon(LucideIcons.check)
                      : null,
                  onTap: () => widget.onCategorySelected(category),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}