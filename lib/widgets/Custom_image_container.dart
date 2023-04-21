import 'package:flutter/material.dart';
import 'package:planttag/utils/Size_config.dart';
import 'package:planttag/widgets/Custom_button.dart';

class CustomImageContainer extends StatelessWidget {
  final String title;
  final String img;
  final String plantsciname;
  final String plantname;
  final String familyname;
  const CustomImageContainer(
      {super.key,
      required this.title,
      required this.img,
      required this.plantsciname,
      required this.plantname,
      required this.familyname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              minLeadingWidth: 0.0,
              visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
              leading: Container(
                height: SizeConfig(context).getProportionateScreenHeight(40),
                width: SizeConfig(context).getProportionateScreenWidth(40),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              ),
              trailing: Container(
                width: 60,
                child: Row(
                  children: [
                    Icon(Icons.group),
                    Icon(Icons.map),
                  ],
                ),
              ),
            ),
            Image.network(
              img,
              height: SizeConfig(context).getProportionateScreenHeight(100),
              width: SizeConfig(context).getProportionateScreenWidth(360),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantsciname,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plantname,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        familyname,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: CustomButton(
                    inptheight: 16,
                    inptwidth: 3,
                    inpttxt: "DETAILS",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    press: () {},
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: CustomButton(
                    inptheight: 16,
                    inptwidth: 3,
                    inpttxt: "VALIDATE",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                    press: () {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
