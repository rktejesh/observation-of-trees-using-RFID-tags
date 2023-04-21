import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String img;
  final String plantsciname;

  const ItemDetailsScreen(
      {super.key, required this.img, required this.plantsciname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.network(img),
          Text("Species"),
          Text("Most probable name"),
          Text(
            plantsciname,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic),
          ),
          Text(
            plantsciname,
            style: TextStyle(
              color: Colors.green,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
