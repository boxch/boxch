import 'dart:io';

import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class AddContactScreen extends StatefulWidget {
  AddContactScreen({ Key? key }) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _controllerContactName = TextEditingController();
  final TextEditingController _controllerSolAddress = TextEditingController();

  File? imageFile;

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
     var cubit = context.read<MainCubit>();
    return BlocProvider<MainCubit>(
      create: (context) => MainCubit(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
                  leading: IconButton(
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
            icon: Icon(Iconsax.arrow_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
              onTap: () => _getFromGallery(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                      height: 120.0,
                      width: 120.0,
                      alignment: Alignment.center,
                      child: imageFile != null ? Image.file(imageFile!, height: 120, width: 120, fit: BoxFit.fill) : Icon(Icons.camera_alt_outlined, color: Colors.grey),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
              ),
            ),
                SizedBox(height: 32.0),
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _controllerContactName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              hintText: "Name",
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _controllerSolAddress,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              hintText: "Address",
                              suffixIcon: InkWell(
                                    onTap: () { 
                                      try {
                                      Clipboard.getData(Clipboard.kTextPlain).then(
                                        (value) => _controllerSolAddress.text = value!.text!);
                                    } catch (_) {} 
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      width: 70.0,
                                      child: Text("Add")),
                                  ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                  ],
                ),
                      SizedBox(height: 32.0),
                      Padding(
                      padding: EdgeInsets.all(32.0),
                      child: InkWell(
                        onTap: () async {
                          if (_controllerSolAddress.text.length > 10) {
                            await cubit.addContact(name: _controllerContactName.text, address: _controllerSolAddress.text, imageUrl: imageFile?.uri.toFilePath() ?? "");
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).cardColor
                          ),
                          child: Text("Add contact", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor)),
                          height: 55.0,
                          width: 200.0,
                        ),
                      ),
                    ),
          ])
      ),
    );
  }

  
}