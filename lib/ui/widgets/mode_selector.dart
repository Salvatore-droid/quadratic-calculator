// ui/widgets/mode_selector.dart
import 'package:flutter/material.dart';
import '../themes/color_palette.dart';

class ModeSelector extends StatefulWidget {
  final List<String> modes;
  final int selectedIndex;
  final Function(int) onModeChanged;

  const ModeSelector({
    super.key,
    required this.modes,
    required this.selectedIndex,
    required this.onModeChanged,
  });

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.modes.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onModeChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: widget.selectedIndex == index
                      ? AppColors.accentBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.modes[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.selectedIndex == index
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}