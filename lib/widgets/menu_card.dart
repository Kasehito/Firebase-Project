import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final int stock;
  final IconData icon;
  final VoidCallback? onAddToOrder;

  const MenuCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.icon,
    this.onAddToOrder, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDEBC9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rp $price',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stok: $stock',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16), // Menambahkan spasi antar elemen
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: onAddToOrder,
              child: const Text('Add to Order'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.orange, // Warna tombol
              ),
            ),
          ),
        ],
      ),
    );
  }
}
