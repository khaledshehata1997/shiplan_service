import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants.dart';


class ZikrCard extends StatefulWidget {
  final String zkr;
  final String text;
   int count;
  late int counter ;

   ZikrCard({super.key, required this.zkr, required this.count, required this.text});

  @override
  State<ZikrCard> createState() => _ZikrCardState();
}

class _ZikrCardState extends State<ZikrCard> {
  @override
  void initState() {
    super.initState();
    widget.counter = widget.count;
  }

  @override
  Widget build(BuildContext context) {


    return  Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child:  Column(
        children: [
          Text(
            widget.zkr,
            style: const TextStyle(
              fontSize: 20,

            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration:  BoxDecoration(
                 border: Border.all(width: 1,color:buttonColor ),
                  shape: BoxShape.circle
                ),
                child: IconButton(onPressed: (){
                  setState(() {
                    widget.counter = widget.count;
                  });
                }, icon:  Icon(Icons.refresh,size: 30,
                  color: Colors.blue[900],)),
              ),
              // SizedBox(
              //   height: Get.height * .08,
              // ),
              Text(
                '${widget.counter}',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              IconButton(
                  onPressed: (){
                    setState(() {
                      if(widget.counter >0){
                        widget.counter --;
                      }

                    });
                  }, icon:  Icon(Icons.remove_circle,size: 50,
                color: Colors.blue[900],))

            ],
          )
        ],
      ),
    );
  }
}
