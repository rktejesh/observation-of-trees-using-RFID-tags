import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planttag/data/api_helper.dart';
import 'package:planttag/pages/choose_species.dart';
import 'package:planttag/utils/Size_config.dart';

class ChooseOrganScreen extends StatelessWidget {
  final List<XFile>? pickedFile;
  const ChooseOrganScreen({super.key, required this.pickedFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Tag',
        ),
      ),
      body: ListView(
        children: [
          Image.file(
            File(pickedFile![0].path),
            errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) =>
                const Center(child: Text('This image type is not supported')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imgcont(
                  "https://st2.depositphotos.com/4203211/6537/i/600/depositphotos_65370103-stock-photo-green-leaf-with-waterdrops-after.jpg",
                  "leaf",
                  context,
                  pickedFile),
              imgcont(
                  "https://s1.1zoom.me/prev/587/Closeup_Roses_Black_background_Red_Drops_586007_600x400.jpg",
                  "flower",
                  context,
                  pickedFile),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imgcont(
                  "https://s1.1zoom.me/prev/379/378687.jpg", "fruit", context,pickedFile),
              imgcont(
                  "https://media.istockphoto.com/id/171298174/photo/closeup-of-tree-trunk.jpg?s=612x612&w=0&k=20&c=jdsnUkZraS4-pIVfSbdjDds37x90x7aowO21y1MbQ9Q=",
                  "bark",
                  context,pickedFile),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imgcont(
                  "https://static.toiimg.com/thumb/width-600,height-400,msid-86184885.cms",
                  "habit",
                  context,pickedFile),
              imgcont(
                  "https://thumbs.dreamstime.com/b/close-up-crochet-red-rose-flower-lichenous-tree-branch-handmade-concept-black-mirror-background-reflection-old-hand-made-259690469.jpg",
                  "other",
                  context, pickedFile),
            ],
          ),
        ],
      ),
    );
  }

  // Future<dynamic> addUserInfo(EditBankDetails editBankDetails) {
  //   print("djflksd");
  //   return FirebaseFirestore.instance
  //       .collection('').doc()
  //       .set(editBankDetails.toJson())
  //       // .then((value))
  //       .catchError((error) => print("Failed to send details: $error"));
  // }

  Widget imgcont(String cnt, String text, BuildContext context, List<XFile>? pickedFile) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseSpeciesScreen(pickedFile: pickedFile, organ: text,)));
      },
      child: Container(
        height: SizeConfig(context).getProportionateScreenHeight(125),
        width: SizeConfig(context).getProportionateScreenWidth(185),
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(cnt), opacity: 0.75),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
