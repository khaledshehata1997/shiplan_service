import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/no product.svg'),
            const SizedBox(height: 30,),
            const Text('No Orders Found',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}