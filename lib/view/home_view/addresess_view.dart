import 'package:flutter/material.dart';

import '../../constants.dart';
class AddresessView extends StatefulWidget {
  const AddresessView({super.key});

  @override
  State<AddresessView> createState() => _AddresessViewState();
}

class _AddresessViewState extends State<AddresessView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('عنوان التوصيل',style: TextStyle(color: Colors.black),),
          ),
      body: Column(
        children: [
          StreamBuilder(
              stream: null,
              builder: (context, snapHost) {
                if (snapHost.hasData) {
                  // return ListView.builder(
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text(document.city),
                  //       subtitle: Text(document.street),
                  //       trailing: IconButton(
                  //         onPressed: () {
                  //           _addressService.deleteAddress(document.id!);
                  //         },
                  //         icon: const Icon(Icons.delete),
                  //       ),
                  //     );
                  //   },
                  // );
                }
                if (snapHost.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                return  Container();
              }),
          SizedBox(height: 35,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(250),
                  backgroundColor: buttonColor),
              onPressed: () {
                // if(FirebaseAuth.instance.currentUser == null){
                //   Get.defaultDialog(
                //       title: "لا يمكن اتمام العمليه\n"
                //           "يجب تسجيل الدخول",
                //       content: Row(
                //         mainAxisAlignment:
                //         MainAxisAlignment.spaceAround,
                //         children: [
                //           ElevatedButton(
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //             child: Text(
                //               'الرجوع'.tr,
                //               style: const TextStyle(
                //                   color: Colors.black),
                //             ),
                //             style: ElevatedButton.styleFrom(
                //                 backgroundColor:
                //                 Colors.white,
                //                 elevation: 10),
                //           ),
                //           ElevatedButton(
                //             onPressed: (){
                //               Navigator.pop(context);
                //               Get.to(const SignIn());
                //             },
                //             child: Text('تسجيل الدخول'.tr,
                //                 style: const TextStyle(
                //                     color: Colors.white)),
                //             style: ElevatedButton.styleFrom(
                //                 backgroundColor: mainColor,
                //                 elevation: 10),
                //           ),
                //         ],
                //       ));
                // }else{
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                          // builder: (context) => const SelectAdressScreen()));


                // _addressService.addAddress(Address(
                //     state: 'state',
                //     postalCode: 'postalCode',
                //     latitude: 23.0,
                //     longitude: 23.0,
                //     city: 'city',
                //     street: 'street',
                //     description: 'country'));
              },
              child: const Text('اضافه عنوان',style: TextStyle(
                  color: Colors.white
              ),))
        ],
      ),
    );
  }
}
