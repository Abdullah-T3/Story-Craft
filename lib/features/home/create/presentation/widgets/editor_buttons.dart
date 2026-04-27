import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditorButtons extends StatelessWidget {
  const EditorButtons({
    super.key,
    required this.onAddPage,
    required this.onEditText,
  });

  final VoidCallback onAddPage;
  final VoidCallback onEditText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildButton(
            icon: Icons.edit_outlined,
            color: const Color(0xFFF5A623),
            onTap: onEditText,
          ),
          SizedBox(width: 12.w),
          _buildButton(
            icon: Icons.add,
            color: const Color(0xFF1E8E5A),
            onTap: onAddPage,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 26.sp,
        ),
      ),
    );
  }
}