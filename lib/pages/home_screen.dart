import 'package:flutter/material.dart';
import 'package:planttag/widgets/Custom_image_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "PLANT TAG",
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          CustomImageContainer(
            title: "kjdslkfs",
            img: "https://firebasestorage.googleapis.com/v0/b/cattleguru-agent-33330.appspot.com/o/products%2Fbinola.png?alt=media&token=ef64f6bb-2908-487f-b5fb-21a94c2d52f7",
            plantsciname: "jflkgd",
            plantname: "kljdlkf",
            familyname: "dhsdlf",
          ),
        ],
      ),
    );
  }
}
