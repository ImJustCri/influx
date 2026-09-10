import 'package:flutter/material.dart';
import '../../../theme.dart';

class CategoryTextContent extends StatelessWidget {
  final String title;
  final String description;

  const CategoryTextContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.expenseTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          description,
          style: AppTypography.expenseDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}