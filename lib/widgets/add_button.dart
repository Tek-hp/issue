import 'package:flutter/material.dart';

class AddOptionButton extends StatelessWidget {
  const AddOptionButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 148,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 12,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Add'),
          ],
        ),
      ),
    );
  }
}
