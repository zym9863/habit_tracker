import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ColorPicker extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ...AppColors.categoryColors.map((color) {
          final colorHex = AppColors.toHex(color);
          final isSelected = colorHex == selectedColor;
          
          return GestureDetector(
            onTap: () => onColorSelected(colorHex),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  : null,
            ),
          );
        }),
      ],
    );
  }
}
