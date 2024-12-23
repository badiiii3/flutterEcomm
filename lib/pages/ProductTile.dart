import 'package:flutter/material.dart';
import 'package:e_commerce/widget/support_widget.dart';

class ProductTile extends StatelessWidget {
  final String image;
  final String name;
  final double price;

  final String category;

  const ProductTile({
    super.key,
    required this.image,
    required this.name,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.network(
            image,
            height: 130.0,
            width: 150.0,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: AppWidget.semiBoldTextFieldStyle(),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                "\$$price",
                style: const TextStyle(
                  color: Color(0xFFfd6f3e),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Handle "Add to Cart" action here
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFfd6f3e),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
