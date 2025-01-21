import 'package:flutter/material.dart';

class EditDeleteDialog extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EditDeleteDialog({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pilih Aksi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onEdit,
            child: const Text('Edit'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onDelete,
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
