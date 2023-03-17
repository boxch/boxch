import 'dart:io';
import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/main/screens/choose_tokens_screen.dart';
import 'package:boxch/models/token.dart';
import 'package:boxch/utils/functions.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class AllContactsScreen extends StatefulWidget {
  final List contacts;
  final List<Token> tokenList;
  AllContactsScreen({ Key? key, required this.contacts, required this.tokenList }) : super(key: key);

  @override
  State<AllContactsScreen> createState() => _AllContactsScreenState();
}

class _AllContactsScreenState extends State<AllContactsScreen> {

  List<GlobalKey> keyList = [];

  @override
  void initState() {
    widget.contacts.forEach((element) { 
      keyList.add(GlobalKey());
     });
    super.initState();
  }

  void swapElements(int first, int second) {
    final temp = widget.contacts[first];
    widget.contacts[first] = widget.contacts[second];
    widget.contacts[second] = temp;
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
          actions: [
            IconButton(onPressed: () => warningShowToast(context, message: "We do not store your contacts and do not allow them to be stored or shared for security purposes"), icon: Icon(Iconsax.info_circle))
          ],
        ),
        body: Column(
          children: [
            GridView.count(
                crossAxisCount: 2,
                children: List.generate(widget.contacts.length, (index) {
                  return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                    onDoubleTap: () {
                      cubit.deleteContact(name: widget.contacts[index]['name'], list: widget.contacts);
                      setState(() {});
                    },
                    onTap: () => replaceWindow(context, ChooseTokensScreen(tokens: widget.tokenList)),
                    child: Column(
                      children: [
                        Draggable(
                          onDraggableCanceled :(velocity,offset){ 

                            for (var i = 0; i < keyList.length; i++) { 
                            var box = keyList[i].currentContext?.findRenderObject() as RenderBox;
                            var position = box.globalToLocal(Offset.zero);

                            if (offset.dx >= position.dx.abs() - 30 && offset.dx <= position.dx.abs() + 30 && offset.dy >= position.dy.abs() - 30 && offset.dy <= position.dy.abs() + 30) {
                                  swapElements(index, i);
                                  cubit.saveNewShape(contactsList: widget.contacts.reversed.toList());
                                  setState(() {});
                              }
                            }
                          
                          } ,
                          feedback: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                                alignment: Alignment.center,
                                height: 90.0,
                                width: 90.0,
                                child: widget.contacts[index]['image'] != "" ? Image.file(File.fromUri(Uri.parse(widget.contacts[index]['image'])), height: 90.0, width: 90.0, fit: BoxFit.fill) : Text(widget.contacts[index]['name'].toString().substring(0, 1), style: TextStyle(fontSize: 21.0)),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                              ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              key: keyList[index],
                              alignment: Alignment.center,
                              height: 90.0,
                              width: 90.0,
                              child: widget.contacts[index]['image'] != "" ? Image.file(File.fromUri(Uri.parse(widget.contacts[index]['image'])), height: 90.0, width: 90.0, fit: BoxFit.fill) : Text(widget.contacts[index]['name'].toString().substring(0, 1), style: TextStyle(fontSize: 21.0)),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20.0)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text("${widget.contacts[index]['name']}"),
                        SizedBox(height: 4.0),
                        Text("${widget.contacts[index]['address'].toString().substring(0, 2)}...${widget.contacts[index]['address'].toString().substring(widget.contacts[index]['address'].toString().length - 5, widget.contacts[index]['address'].toString().length)}")
                      ],
                    ),
                  );
                }),
                ),
              Container(height: 60.0, width: MediaQuery.of(context).size.width, color: Colors.amber)
          ],
        ),
      ),
    );
  }
}