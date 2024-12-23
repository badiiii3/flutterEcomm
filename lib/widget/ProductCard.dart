import 'package:e_commerce/widget/support_widget.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  ProductCard({super.key, required this.name, required this.price, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 130.0,
            width: 150.0,
            fit: BoxFit.cover,
          ),
          Text(
            name,
            style: AppWidget.semiBoldTextFieldStyle(),
          ),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20.0),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
