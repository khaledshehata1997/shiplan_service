import 'dart:io';
import 'dart:ui' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiplan_service/view/prayer_app/azkar/widget/zikr_card.dart';

import 'azkary_view.dart';


class Azkar extends StatefulWidget {
  const Azkar({super.key});

  @override
  State<Azkar> createState() => _AzkarState();
}

class _AzkarState extends State<Azkar> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath1');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  _openImagePicker() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imagePath1', pickedFile.path);
    }
  }

  _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'من فضلك اختار صورة',
            textDirection: TextDirection.rtl,
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                child: Text(
                  'اختار',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _openImagePicker();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          onPressed: () => _showImagePickerDialog(context),
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   width: MediaQuery.of(context).size.width,
              //   //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage('images/back ground2.jpeg'),
              //         fit: BoxFit.cover),
              //     borderRadius: BorderRadius.circular(1),
              //     color: Colors.white,
              //   ),
              // ),
              ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30,top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () async {
                        //         final userData = await getUserData();
                        //         if(FirebaseAuth.instance.currentUser == null){
                        //           Get.snackbar("لا يمكن الدخول الي الصفحه الشخصيه", "للدخول الي الصفحه الشخصيه برجاء تسجيل الدخول",
                        //               colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,
                        //               backgroundColor: Colors.blue[900]);
                        //           Get.to(SignInView());
                        //         }else{
                        //           PersistentNavBarNavigator.pushNewScreen(
                        //             context,
                        //             screen:  Profile(username: '${userData['username']}',
                        //               email: '${userData['email']}',),
                        //             withNavBar: true, // OPTIONAL VALUE. True by default.
                        //             pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        //           );
                        //         }
                        //       },
                        //       child: CircleAvatar(
                        //         radius: 25,
                        //         backgroundColor: Colors.grey.shade400,
                        //         child: Image.asset(
                        //           'icons/img_1.png',
                        //           width: 20,
                        //           height: 20,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     PersistentNavBarNavigator.pushNewScreen(
                            //       context,
                            //       screen: const Settings(),
                            //       withNavBar: true, // OPTIONAL VALUE. True by default.
                            //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            //     );
                            //   },
                            //   child: CircleAvatar(
                            //     radius: 25,
                            //     child: Image.asset(
                            //       'icons/img.png',
                            //       width: 20,
                            //       height: 20,
                            //     ),
                            //     backgroundColor: Colors.grey.shade400,
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .15,
                  ),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     Image.asset(
                  //       'images/back ground2.jpeg',
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 15),
                  //       child: Column(
                  //         children: [
                  //           Container(
                  //             alignment: Alignment.center,
                  //             child: Text(
                  //               ': ذكر اليوم',
                  //               style: TextStyle(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white),
                  //             ),
                  //           ),
                  //           Container(
                  //             alignment: Alignment.center,
                  //             child: Text(
                  //               'لا اله الا انت سبحانك اني كنت من الظالمين',
                  //               style: TextStyle(
                  //                   fontSize: 17,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white),
                  //               textDirection: TextDirection.rtl,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Container(
                      margin: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: Get.height * .8,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: GridView(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.25,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2),
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: Get.height * .04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'اذكار الصباح',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.to(Sabah());
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: Get.height * .04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'اذكار المساء',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  Get.to(Masaa());
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: Get.height * .04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'اذكار المسجد',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.to(Masjed());
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: Get.height * .04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'اذكار الصلاه',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.to(Alsalah());
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: Get.height * .04,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'اذكار النوم',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.to(Alnawm());
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: Get.height * .03,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'اذكاري ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Get.to(Azkary(
                                    image: _image,
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}

class Sabah extends StatefulWidget {
  @override
  State<Sabah> createState() => _SabahState();
}

class _SabahState extends State<Sabah> {
  int counter = 0;
  String x = ' سبحان الله العظيم';

  void incrementCounter() {
    setState(() {
      counter++;
      printer();
      if (counter == 33) {
        print(Text('more'));
      }
    });
  }

  void zero() {
    setState(() {
      counter = 0;
    });
  }

  void printer() {
    setState(() {
      if (counter <= 33) {
        x = (' سبحان الله العظيم');
      } else if (counter <= 66 && counter > 33) {
        x = ('الحمد الله');
      } else if (counter <= 99 && counter > 66) {
        x = ('الله اكبر');
      } else if (counter > 99) {
        counter = 0;
        x = (' سبحان الله العظيم');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('images/back ground.jpeg'),
          //         fit: BoxFit.cover),
          //     borderRadius: BorderRadius.circular(1),
          //     color: Colors.white,
          //   ),
          // ),
          Column(
            children: [
              // SizedBox(
              //   height: Get.height * 0.05,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final userData = await getUserData();
                    //         Get.to(Profile(
                    //           username: '${userData['username']}',
                    //           email: '${userData['email']}',
                    //         ));
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: Colors.grey.shade400,
                    //         child: Image.asset(
                    //           'icons/img_1.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     // CircleAvatar(
                    //     //   child: Icon(Icons.notifications_none),
                    //     //   backgroundColor: Colors.grey.shade400,
                    //     //   radius: 20,
                    //     // ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //       //  Get.to(const Settings());
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: Colors.grey.shade400,
                    //         child: Image.asset(
                    //           'icons/img.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
              // SizedBox(
              //   height: Get.height * 0.04,
              // ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/back ground2.jpeg',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'أذكار الصباح',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Expanded(
                child: ListView(
                  children:  <Widget>[
                    Column(
                      children: <Widget>[
                        ZikrCard(
                          zkr: 'اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلاَّ بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ.',
                          text: "مره واحده",count: 1,
                        ),
                        ZikrCard(
                            zkr: "قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّالنَّفَّاثَاتِ فِي الْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدٌَ",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَهِ النَّاسِ، مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ، الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ، مِنَ الْجِنَّةِ وَ النَّاسِ",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr: "أَصْـبَحْنا وَأَصْـبَحَ المُـلْكُ لله وَالحَمدُ لله ، لا إلهَ إلاّ اللّهُ وَحدَهُ لا شَريكَ لهُ، لهُ المُـلكُ ولهُ الحَمْـد، وهُوَ على كلّ شَيءٍ قدير ، رَبِّ أسْـأَلُـكَ خَـيرَ ما في هـذا اليوم وَخَـيرَ ما بَعْـدَه ، وَأَعـوذُ بِكَ مِنْ شَـرِّ ما في هـذا اليوم وَشَرِّ ما بَعْـدَه، رَبِّ أَعـوذُ بِكَ مِنَ الْكَسَـلِ وَسـوءِ الْكِـبَر ، رَبِّ أَعـوذُ بِكَ مِنْ عَـذابٍ في النّـارِ وَعَـذابٍ في القَـبْر ِ",
                           text:  "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr: "أاللّهـمَّ أَنْتَ رَبِّـي لا إلهَ إلاّ أَنْتَ ، خَلَقْتَنـي وَأَنا عَبْـدُك ، وَأَنا عَلـى عَهْـدِكَ وَوَعْـدِكَ ما اسْتَـطَعْـت ، أَعـوذُ بِكَ مِنْ شَـرِّ ما صَنَـعْت ، أَبـوءُ لَـكَ بِنِعْـمَتِـكَ عَلَـيَّ وَأَبـوءُ بِذَنْـبي فَاغْفـِرْ لي فَإِنَّـهُ لا يَغْـفِرُ الذُّنـوبَ إِلاّ أَنْت ِ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr:  "رَضيـتُ بِاللهِ رَبَّـاً وَبِالإسْلامِ ديـناً وَبِمُحَـمَّدٍ صلى الله عليه وسلم نَبِيّـاً",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللّهُـمَّ إِنِّـي أَصْبَـحْتُ أُشْـهِدُك ، وَأُشْـهِدُ حَمَلَـةَ عَـرْشِـك ، وَمَلائِكَتِك ، وَجَمـيعَ خَلْـقِك ، أَنَّـكَ أَنْـتَ اللهُ لا إلهَ إلاّ أَنْـتَ وَحْـدَكَ لا شَريكَ لَـك ، وَأَنَّ مُحَمّـداً عَبْـدُكَ وَرَسـولُـك. .ًِ",
                           text:  "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr: "اللّهُـمَّ ما أَصْبَـَحَ بي مِـنْ نِعْـمَةٍ أَو بِأَحَـدٍ مِـنْ خَلْـقِك ، فَمِـنْكَ وَحْـدَكَ لا شريكَ لَـك ، فَلَـكَ الْحَمْـدُ وَلَـكَ الشُّكْـر ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "حَسْبِـيَ اللّهُ لا إلهَ إلاّ هُوَ عَلَـيهِ تَوَكَّـلتُ وَهُوَ رَبُّ العَرْشِ العَظـيم.",
                            text: "سبع مرات",count: 7,
                            ),
                        ZikrCard(
                           zkr:  "بِسـمِ اللهِ الذي لا يَضُـرُّ مَعَ اسمِـهِ شَيءٌ في الأرْضِ وَلا في السّمـاءِ وَهـوَ السّمـيعُ العَلـيم.",
                           text:  "ثلاث مرات",count:3,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ بِكَ أَصْـبَحْنا وَبِكَ أَمْسَـينا ، وَبِكَ نَحْـيا وَبِكَ نَمُـوتُ وَإِلَـيْكَ النُّـشُور.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "سُبْحـانَ اللهِ وَبِحَمْـدِهِ عَدَدَ خَلْـقِه ، وَرِضـا نَفْسِـه ، وَزِنَـةَ عَـرْشِـه ، وَمِـدادَ كَلِمـاتِـه.",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ عافِـني في بَدَنـي ، اللّهُـمَّ عافِـني في سَمْـعي ، اللّهُـمَّ عافِـني في بَصَـري ، لا إلهَ إلاّ أَنْـتَ.",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللّهُـمَّ إِنّـي أَعـوذُ بِكَ مِنَ الْكُـفر ، وَالفَـقْر ، وَأَعـوذُ بِكَ مِنْ عَذابِ القَـبْر ، لا إلهَ إلاّ أَنْـتَ.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللّهُـمَّ إِنِّـي أسْـأَلُـكَ العَـفْوَ وَالعـافِـيةَ في الدُّنْـيا وَالآخِـرَة ، اللّهُـمَّ إِنِّـي أسْـأَلُـكَ العَـفْوَ وَالعـافِـيةَ في ديني وَدُنْـيايَ وَأهْـلي وَمالـي ، اللّهُـمَّ اسْتُـرْ عـوْراتي وَآمِـنْ رَوْعاتـي ، اللّهُـمَّ احْفَظْـني مِن بَـينِ يَدَيَّ وَمِن خَلْفـي وَعَن يَمـيني وَعَن شِمـالي ، وَمِن فَوْقـي ، وَأَعـوذُ بِعَظَمَـتِكَ أَن أُغْـتالَ مِن تَحْتـي.",
                           text: "مره واحده", count: 1,
                            ),
                        ZikrCard(
                           zkr: "يا حَـيُّ يا قَيّـومُ بِـرَحْمَـتِكَ أَسْتَـغـيث ، أَصْلِـحْ لي شَـأْنـي كُلَّـه ، وَلا تَكِلـني إِلى نَفْـسي طَـرْفَةَ عَـين.",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "أَصْبَـحْـنا وَأَصْبَـحْ المُـلكُ للهِ رَبِّ العـالَمـين ، اللّهُـمَّ إِنِّـي أسْـأَلُـكَ خَـيْرَ هـذا الـيَوْم ، فَـتْحَهُ ، وَنَصْـرَهُ ، وَنـورَهُ وَبَـرَكَتَـهُ ، وَهُـداهُ ، وَأَعـوذُ بِـكَ مِـنْ شَـرِّ ما فـيهِ وَشَـرِّ ما بَعْـدَه.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr:  "اللّهُـمَّ عالِـمَ الغَـيْبِ وَالشّـهادَةِ فاطِـرَ السّماواتِ وَالأرْضِ رَبَّ كـلِّ شَـيءٍ وَمَليـكَه ، أَشْهَـدُ أَنْ لا إِلـهَ إِلاّ أَنْت ، أَعـوذُ بِكَ مِن شَـرِّ نَفْسـي وَمِن شَـرِّ الشَّيْـطانِ وَشِـرْكِه ، وَأَنْ أَقْتَـرِفَ عَلـى نَفْسـي سوءاً أَوْ أَجُـرَّهُ إِلـى مُسْـلِم.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "عـوذُ بِكَلِمـاتِ اللّهِ التّـامّـاتِ مِنْ شَـرِّ ما خَلَـق.",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ على نَبِيِّنَا مُحمَّد",
                           text:  "عشر مرات",count: 10,
                            ),
                        ZikrCard(
                           zkr:  "اللَّهُمَّ إِنَّا نَعُوذُ بِكَ مِنْ أَنْ نُشْرِكَ بِكَ شَيْئاً نَعْلَمُهُ ، وَنَسْتَغْفِرُكَ لِمَا لَا نَعْلَمُه",
                            text: "ثلاث مرات", count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنْ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنْ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ، وَقَهْرِ الرِّجَالِ.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "أسْتَغْفِرُ اللهَ العَظِيمَ الَّذِي لاَ إلَهَ إلاَّ هُوَ، الحَيُّ القَيُّومُ، وَأتُوبُ إلَيهِ.",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr: "يَا رَبِّ , لَكَ الْحَمْدُ كَمَا يَنْبَغِي لِجَلَالِ وَجْهِكَ , وَلِعَظِيمِ سُلْطَانِكَ.",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "لا إلهَ إلاّ اللّهُ وَحَدُّهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءِ قَدِيرِ.",
                            text: "عشر مرات",count: 10,
                            ),
                        ZikrCard(
                            zkr: "اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ ، عَلَيْكَ تَوَكَّلْتُ ، وَأَنْتَ رَبُّ الْعَرْشِ الْكَرِيمِ , مَا شَاءَ اللَّهُ كَانَ ، وَمَا لَمْ يَشَأْ لَمْ يَكُنْ ، وَلا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ , أَعْلَمُ أَنَّ اللَّهَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ ، وَأَنَّ اللَّهَ قَدْ أَحَاطَ بِكُلِّ شَيْءٍ عِلْمًا , اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي ، وَمِنْ شَرِّ كُلِّ دَابَّةٍ أَنْتَ آخِذٌ بِنَاصِيَتِهَا ، إِنَّ رَبِّي عَلَى صِرَاطٍ مُسْتَقِيمٍ.",
                           text: "مره واحده",count: 1,
                            ),
                        ZikrCard(zkr: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", text: "مائه مره",count: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Masaa extends StatefulWidget {
  @override
  State<Masaa> createState() => _MasaaState();
}

class _MasaaState extends State<Masaa> {
  int counter = 0;

  String x = ' سبحان الله العظيم';

  void incrementCounter() {
    setState(() {
      counter++;
      printer();
      if (counter == 33) {
        print(Text('more'));
      }
    });
  }

  void zero() {
    setState(() {
      counter = 0;
    });
  }

  void printer() {
    setState(() {
      if (counter <= 33) {
        x = (' سبحان الله العظيم');
      } else if (counter <= 66 && counter > 33) {
        x = ('الحمد الله');
      } else if (counter <= 99 && counter > 66) {
        x = ('الله اكبر');
      } else if (counter > 99) {
        counter = 0;
        x = (' سبحان الله العظيم');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('images/back ground.jpeg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(1),
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              // SizedBox(
              //   height: Get.height * 0.05,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final userData = await getUserData();
                    //         Get.to(Profile(
                    //           username: '${userData['username']}',
                    //           email: '${userData['email']}',
                    //         ));
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: Colors.grey.shade400,
                    //         child: Image.asset(
                    //           'icons/img_1.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     // CircleAvatar(
                    //     //   child: Icon(Icons.notifications_none),
                    //     //   backgroundColor: Colors.grey.shade400,
                    //     //   radius: 20,
                    //     // ),
                    //     SizedBox(
                    //       width: 8,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //        // Get.to(const Settings());
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         child: Image.asset(
                    //           'icons/img.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //         backgroundColor: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/back ground2.jpeg',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'أذكار المساء',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Expanded(
                child: ListView(
                  children:  <Widget>[
                    Column(
                      children: <Widget>[
                        ZikrCard(
                            zkr: "اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلاَّ بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ.ٌ",
                           text:  "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِنْ رُسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ. لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ.ٌ",
                           text:  "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
                           text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّالنَّفَّاثَاتِ فِي الْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَد",
                           text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَهِ النَّاسِ، مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ، الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ، مِنَ الْجِنَّةِ وَ النَّاسِ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "أَمْسَيْـنا وَأَمْسـى المـلكُ لله وَالحَمدُ لله ، لا إلهَ إلاّ اللّهُ وَحدَهُ لا شَريكَ لهُ، لهُ المُـلكُ ولهُ الحَمْـد، وهُوَ على كلّ شَيءٍ قدير ، رَبِّ أسْـأَلُـكَ خَـيرَ ما في هـذهِ اللَّـيْلَةِ وَخَـيرَ ما بَعْـدَهـا ، وَأَعـوذُ بِكَ مِنْ شَـرِّ ما في هـذهِ اللَّـيْلةِ وَشَرِّ ما بَعْـدَهـا ، رَبِّ أَعـوذُبِكَ مِنَ الْكَسَـلِ وَسـوءِ الْكِـبَر ، رَبِّ أَعـوذُبِكَ مِنْ عَـذابٍ في النّـارِ وَعَـذابٍ في القَـبْر.ِ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "أاللّهـمَّ أَنْتَ رَبِّـي لا إلهَ إلاّ أَنْتَ ، خَلَقْتَنـي وَأَنا عَبْـدُك ، وَأَنا عَلـى عَهْـدِكَ وَوَعْـدِكَ ما اسْتَـطَعْـت ، أَعـوذُ بِكَ مِنْ شَـرِّ ما صَنَـعْت ، أَبـوءُ لَـكَ بِنِعْـمَتِـكَ عَلَـيَّ وَأَبـوءُ بِذَنْـبي فَاغْفـِرْ لي فَإِنَّـهُ لا يَغْـفِرُ الذُّنـوبَ إِلاّ أَنْتً",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "رَضيـتُ بِاللهِ رَبَّـاً وَبِالإسْلامِ ديـناً وَبِمُحَـمَّدٍ صلى الله عليه وسلم نَبِيّـاًً",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ إِنِّـي أَمسيتُ أُشْـهِدُك ، وَأُشْـهِدُ حَمَلَـةَ عَـرْشِـك ، وَمَلائِكَتِك ، وَجَمـيعَ خَلْـقِك ، أَنَّـكَ أَنْـتَ اللهُ لا إلهَ إلاّ أَنْـتَ وَحْـدَكَ لا شَريكَ لَـك ، وَأَنَّ ُ مُحَمّـداً عَبْـدُكَ وَرَسـولُـك ",
                           text:  "اربع مرات",count: 4,
                            ),
                        ZikrCard(
                           zkr: "حَسْبِـيَ اللّهُ لا إلهَ إلاّ هُوَ عَلَـيهِ تَوَكَّـلتُ وَهُوَ رَبُّ العَرْشِ العَظـيم",
                            text: "سبع مرات",count: 7,
                            ),
                        ZikrCard(
                           zkr:  "بِسـمِ اللهِ الذي لا يَضُـرُّ مَعَ اسمِـهِ شَيءٌ في الأرْضِ وَلا في السّمـاءِ وَهـوَ السّمـيعُ العَلـيم.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللّهُـمَّ بِكَ أَمْسَـينا وَبِكَ أَصْـبَحْنا، وَبِكَ نَحْـيا وَبِكَ نَمُـوتُ وَإِلَـيْكَ الْمَصِيرُ.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr: "أَمْسَيْنَا عَلَى فِطْرَةِ الإسْلاَمِ، وَعَلَى كَلِمَةِ الإِخْلاَصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إبْرَاهِيمَ حَنِيفاً مُسْلِماً وَمَا كَانَ مِنَ المُشْرِكِينَ.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "سُبْحـانَ اللهِ وَبِحَمْـدِهِ عَدَدَ خَلْـقِه ، وَرِضـا نَفْسِـه ، وَزِنَـةَ عَـرْشِـه ، وَمِـدادَ كَلِمـاتِـه.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ عافِـني في بَدَنـي ، اللّهُـمَّ عافِـني في سَمْـعي ، اللّهُـمَّ عافِـني في بَصَـري ، لا إلهَ إلاّ أَنْـتَ.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ إِنّـي أَعـوذُبِكَ مِنَ الْكُـفر ، وَالفَـقْر ، وَأَعـوذُبِكَ مِنْ عَذابِ القَـبْر ، لا إلهَ إلاّ أَنْـت.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr: "اللّهُـمَّ إِنِّـي أسْـأَلُـكَ العَـفْوَ وَالعـافِـيةَ في الدُّنْـيا وَالآخِـرَة ، اللّهُـمَّ إِنِّـي أسْـأَلُـكَ العَـفْوَ وَالعـافِـيةَ في ديني وَدُنْـيايَ وَأهْـلي وَمالـي ، اللّهُـمَّ اسْتُـرْ عـوْراتي وَآمِـنْ رَوْعاتـي ، اللّهُـمَّ احْفَظْـني مِن بَـينِ يَدَيَّ وَمِن خَلْفـي وَعَن يَمـيني وَعَن شِمـالي ، وَمِن فَوْقـي ، وَأَعـوذُ بِعَظَمَـتِكَ أَن أُغْـتالَ مِن تَحْتـي.",
                           text:  "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "يا حَـيُّ يا قَيّـومُ بِـرَحْمَـتِكَ أَسْتَـغـيث ، أَصْلِـحْ لي شَـأْنـي كُلَّـه ، وَلا تَكِلـني إِلى نَفْـسي طَـرْفَةَ عَـين.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "أَمْسَيْنا وَأَمْسَى الْمُلْكُ للهِ رَبِّ الْعَالَمَيْنِ، اللَّهُمَّ إِنَّي أسْأَلُكَ خَيْرَ هَذَه اللَّيْلَةِ فَتْحُهَا وَنُصَرُّهَا، وَنورَهُا و برَكَتَهُا، وَهُداهُا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فيهِا وَشَرَّ مَا بَعْدَهَا.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ عالِـمَ الغَـيْبِ وَالشّـهادَةِ فاطِـرَ السّماواتِ وَالأرْضِ رَبَّ كـلِّ شَـيءٍ وَمَليـكَه ، أَشْهَـدُ أَنْ لا إِلـهَ إِلاّ أَنْت ، أَعـوذُ بِكَ مِن شَـرِّ نَفْسـي وَمِن شَـرِّ الشَّيْـطانِ وَشِـرْكِه ، وَأَنْ أَقْتَـرِفَ عَلـى نَفْسـي سوءاً أَوْ أَجُـرَّهُ إِلـى مُسْـلِم.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr:  "أَعـوذُ بِكَلِمـاتِ اللّهِ التّـامّـاتِ مِنْ شَـرِّ ما خَلَـق.",
                           text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "اللَّهُمَّ إِنَّا نَعُوذُ بِكَ مِنْ أَنْ نُشْرِكَ بِكَ شَيْئًا نَعْلَمُهُ ، وَنَسْتَغْفِرُكَ لِمَا لَا نَعْلَمُهُ",
                            text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ على نَبِيِّنَا مُحمَّد.",
                            text: "عشر مرات",count: 10,
                            ),
                        ZikrCard(
                           zkr:  "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنْ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنْ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ، وَقَهْرِ الرِّجَالِ.",
                           text:  "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                           zkr:  "أسْتَغْفِرُ اللهَ العَظِيمَ الَّذِي لاَ إلَهَ إلاَّ هُوَ، الحَيُّ القَيُّومُ، وَأتُوبُ إلَيهِ.",
                           text: "ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: "يَا رَبِّ , لَكَ الْحَمْدُ كَمَا يَنْبَغِي لِجَلَالِ وَجْهِكَ , وَلِعَظِيمِ سُلْطَانِكَ.",
                           text:  "ثلاث مرات", count: 3,
                            ),
                        ZikrCard(
                           zkr: "ا إلَه إلّا اللهُ وَحَدُّهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلُّ شَيْءِ قَدِيرِ.",
                            text: "عشر مرات",count: 10,
                            ),
                        ZikrCard(
                            zkr: "اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ ، عَلَيْكَ تَوَكَّلْتُ ، وَأَنْتَ رَبُّ الْعَرْشِ الْكَرِيمِ , مَا شَاءَ اللَّهُ كَانَ ، وَمَا لَمْ يَشَأْ لَمْ يَكُنْ ، وَلا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ , أَعْلَمُ أَنَّ اللَّهَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ ، وَأَنَّ اللَّهَ قَدْ أَحَاطَ بِكُلِّ شَيْءٍ عِلْمًا , اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي ، وَمِنْ شَرِّ كُلِّ دَابَّةٍ أَنْتَ آخِذٌ بِنَاصِيَتِهَا ، إِنَّ رَبِّي عَلَى صِرَاطٍ مُسْتَقِيمٍ.ِ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(zkr: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", text: "مائه مره",count: 100,),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Masjed extends StatefulWidget {
  @override
  State<Masjed> createState() => _MasjedState();
}

class _MasjedState extends State<Masjed> {
  int counter = 0;

  String x = ' سبحان الله العظيم';

  void incrementCounter() {
    setState(() {
      counter++;
      printer();
      if (counter == 33) {
        print(Text('more'));
      }
    });
  }

  void zero() {
    setState(() {
      counter = 0;
    });
  }

  void printer() {
    setState(() {
      if (counter <= 33) {
        x = (' سبحان الله العظيم');
      } else if (counter <= 66 && counter > 33) {
        x = ('الحمد الله');
      } else if (counter <= 99 && counter > 66) {
        x = ('الله اكبر');
      } else if (counter > 99) {
        counter = 0;
        x = (' سبحان الله العظيم');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/back ground.jpeg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(1),
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              // SizedBox(
              //   height: Get.height * 0.05,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final userData = await getUserData();
                    //         Get.to(Profile(
                    //           username: '${userData['username']}',
                    //           email: '${userData['email']}',
                    //         ));
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: Colors.grey.shade400,
                    //         child: Image.asset(
                    //           'icons/img_1.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     // CircleAvatar(
                    //     //   child: Icon(Icons.notifications_none),
                    //     //   backgroundColor: Colors.grey.shade400,
                    //     //   radius: 20,
                    //     // ),
                    //     SizedBox(
                    //       width: 8,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //       //  Get.to(const Settings());
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         child: Image.asset(
                    //           'icons/img.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //         backgroundColor: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/back ground2.jpeg',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'أذكار المسجد',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Expanded(
                child: ListView(
                  children:  <Widget>[
                    Column(
                      children: <Widget>[
                        ZikrCard(
                            zkr: "قبل الذهاب إلى المسجد : اللّهُـمَّ اجْعَـلْ في قَلْبـي نورا ، وَفي لِسـاني نورا، وَاجْعَـلْ في سَمْعي نورا، وَاجْعَـلْ في بَصَري نورا، وَاجْعَـلْ مِنْ خَلْفي نورا، وَمِنْ أَمامـي نورا، وَاجْعَـلْ مِنْ فَوْقـي نورا ، وَمِن تَحْتـي نورا .اللّهُـمَّ أَعْطِنـي نوراٌ",
                           text:  "مره واحده", count: 1,
                            ),
                        ZikrCard(
                           zkr:  "الدخول للمسجد : أَعوذُ باللهِ العَظيـم وَبِوَجْهِـهِ الكَرِيـم وَسُلْطـانِه القَديـم مِنَ الشّيْـطانِ الرَّجـيم،[ بِسْـمِ الله، وَالصَّلاةُ وَالسَّلامُ عَلى رَسولِ الله]، اللّهُـمَّ افْتَـحْ لي أَبْوابَ رَحْمَتـِك.ٌ",
                           text:  "مره واحده", count: 1,
                            ),
                        ZikrCard(
                            zkr: "الخروج من المسجد : بِسمِ الله وَالصّلاةُ وَالسّلامُ عَلى رَسولِ الله، اللّهُـمَّ إِنّـي أَسْأَلُكَ مِـنْ فَضْـلِك، اللّهُـمَّ اعصِمْنـي مِنَ الشَّيْـطانِ الرَّجـيمٌ",
                           text:  " مره واحده",count: 1,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Alsalah extends StatefulWidget {
  @override
  State<Alsalah> createState() => _AlsalahState();
}

class _AlsalahState extends State<Alsalah> {
  int counter = 0;

  String x = ' سبحان الله العظيم';

  void incrementCounter() {
    setState(() {
      counter++;
      printer();
      if (counter == 33) {
        print(Text('more'));
      }
    });
  }

  void zero() {
    setState(() {
      counter = 0;
    });
  }

  void printer() {
    setState(() {
      if (counter <= 33) {
        x = (' سبحان الله العظيم');
      } else if (counter <= 66 && counter > 33) {
        x = ('الحمد الله');
      } else if (counter <= 99 && counter > 66) {
        x = ('الله اكبر');
      } else if (counter > 99) {
        counter = 0;
        x = (' سبحان الله العظيم');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/back ground.jpeg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(1),
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              // SizedBox(
              //   height: Get.height * 0.05,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       // onTap: () async {
                    //       //   final userData = await getUserData();
                    //       //   Get.to(Profile(
                    //       //     username: '${userData['username']}',
                    //       //     email: '${userData['email']}',
                    //       //   ));
                    //       // },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: Colors.grey.shade400,
                    //         child: Image.asset(
                    //           'icons/img_1.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     // CircleAvatar(
                    //     //   child: Icon(Icons.notifications_none),
                    //     //   backgroundColor: Colors.grey.shade400,
                    //     //   radius: 20,
                    //     // ),
                    //     SizedBox(
                    //       width: 8,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //        // Get.to(const Settings());
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         child: Image.asset(
                    //           'icons/img.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //         backgroundColor: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/back ground2.jpeg',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'أذكار الصلاه',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        ZikrCard(
                           zkr:"أسـتغفر الله، أسـتغفر الله، أسـتغفر الله. اللهـم أنـت السلام ، ومـنك السلام ، تباركت يا ذا الجـلال والإكـرامٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr:"لا إله إلا الله وحده لا شريك له، له المـلك وله الحمد، وهو على كل شيء قدير، اللهـم لا مانع لما أعطـيت، ولا معطـي لما منـعت، ولا ينفـع ذا الجـد منـك الجـد.ٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr:  "لا إله إلا الله, وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير، لا حـول ولا قـوة إلا بالله، لا إله إلا اللـه، ولا نعـبـد إلا إيـاه, له النعـمة وله الفضل وله الثـناء الحـسن، لا إله إلا الله مخلصـين لـه الدين ولو كـره الكـافرون.ٌ",
                           text:  " مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "سـبحان الله، والحمـد لله ، والله أكـبر. (ثلاثا وثلاثين). لا إله إلا الله وحـده لا شريك له، له الملك وله الحمد، وهو على كل شيء قـدير.ٌ",
                           text:  "ثلاث وثلاثين",count: 33,
                            ),
                        ZikrCard(
                            zkr: "أعوذ بالله من الشيطان الرجيم : {اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ}",
                           text:  " مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "أعوذ بالله من الشيطان الرجيم : {اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ}ٌ",
                           text:  " مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr: "بسم الله الرحمن الرحيم : {قُلْ هُوَ اللَّهُ أَحَدٌ * اللَّهُ الصَّمَدُ * لَمْ يَلِدْ وَلَمْ يُولَدْ * وَلَمْ يَكُن لَّهُ كُفُواً أَحَدٌ}ٌ",
                            text: " مره واحده",count: 1,
                            ),
                        ZikrCard(
                           zkr: "بسم الله الرحمن الرحيم : {قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ * مِن شَرِّ مَا خَلَقَ * وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ * وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ * وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ}ٌ",
                            text: " مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "بسم الله الرحمن الرحيم : {قُلْ أَعُوذُ بِرَبِّ النَّاسِ * مَلِكِ النَّاسِ * إِلَهِ النَّاسِ * مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ * الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ * مِنَ الْجِنَّةِ وَالنَّاسِ}ٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "لا إله إلا الله وحـده لا شريك له، له الملك وله الحمد، يحيـي ويمـيت وهو على كل شيء قديرٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "اللهـم إنـي أسألـك علمـا نافعـا ورزقـا طيـبا ، وعمـلا متقـبلا .ٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(zkr: "اللهم أجرنى من النارٌ", text: "مره واحده",count: 1,),
                        ZikrCard(
                            zkr: "اللهـم أعنى على ذكرك وشكرك وحسن عبادتك.ٌ",
                            text: "مره واحده",count: 1,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Alnawm extends StatefulWidget {
  @override
  State<Alnawm> createState() => _AlnawmState();
}

class _AlnawmState extends State<Alnawm> {
  int counter = 0;

  String x = ' سبحان الله العظيم';

  void incrementCounter() {
    setState(() {
      counter++;
      printer();
      if (counter == 33) {
        print(Text('more'));
      }
    });
  }

  void zero() {
    setState(() {
      counter = 0;
    });
  }

  void printer() {
    setState(() {
      if (counter <= 33) {
        x = (' سبحان الله العظيم');
      } else if (counter <= 66 && counter > 33) {
        x = ('الحمد الله');
      } else if (counter <= 99 && counter > 66) {
        x = ('الله اكبر');
      } else if (counter > 99) {
        counter = 0;
        x = (' سبحان الله العظيم');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  margin: EdgeInsets.only(left: 2, top: 5, bottom: 5, right: 2),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/back ground.jpeg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(1),
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              // SizedBox(
              //   height: Get.height * 0.05,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       // onTap: () async {
                    //       //   final userData = await getUserData();
                    //       //   Get.to(Profile(
                    //       //     username: '${userData['username']}',
                    //       //     email: '${userData['email']}',
                    //       //   ));
                    //       // },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: Colors.grey.shade400,
                    //         child: Image.asset(
                    //           'icons/img_1.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     // CircleAvatar(
                    //     //   child: Icon(Icons.notifications_none),
                    //     //   backgroundColor: Colors.grey.shade400,
                    //     //   radius: 20,
                    //     // ),
                    //     SizedBox(
                    //       width: 8,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         //Get.to(const Settings());
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 20,
                    //         child: Image.asset(
                    //           'icons/img.png',
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //         backgroundColor: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/back ground2.jpeg',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'أذكار النوم',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Expanded(
                child: ListView(
                  children:  <Widget>[
                    Column(
                      children: <Widget>[
                        ZikrCard(
                            zkr: "أ– بِإسْمِكَ رَبِّـي وَضَعْـتُ جَنْـبي، وَبِكَ أَرْفَعُـه، فَإِن أَمْسَـكْتَ نَفْسـي فارْحَـمْها، وَإِنْ أَرْسَلْتَـها فاحْفَظْـها بِمـا تَحْفَـظُ بِه عِبـادَكَ الصّـالِحـين.ٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ إِنَّـكَ خَلَـقْتَ نَفْسـي وَأَنْـتَ تَوَفّـاهـا لَكَ ممَـاتـها وَمَحْـياها، إِنْ أَحْيَيْـتَها فاحْفَظْـها، وَإِنْ أَمَتَّـها فَاغْفِـرْ لَـها. اللّهُـمَّ إِنَّـي أَسْـأَلُـكَ العـافِـيَة.ٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "بِإسْـمِكَ اللّهُـمَّ أَمـوتُ وَأَحْـيا.ٌ",
                            text: " مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: " اللّهُمَّ عالِمَ الغَـيبِ وَالشّهادةِ فاطِرَ السّماواتِ وَالأرْضِ رَبَّ كُـلِّ شَيءٍ وَمَليـكَه، أَشْهدُ أَنّ لا إِلـهَ إِلاّ أَنْت، أَعوذُ بِكَ مِن شَرِّ نَفْسي، وَمِن شَـرِّ الشَّيْطانِ وَشِـرْكِه، وَأَنْ أَقْتَـرِفَ عَلى نَفْسي سُوءاً أَوْ أَجُرَّهُ إِلى مُسْلِم.",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "اللّهُمَّ أَسْلَمْتُ نَفْسي إِلَيْكَ، وَفَوَّضْتُ أَمْري إِلَيْكَ، وَوَجَّهْتُ وَجْهي إِلَـيْكَ، وَأَلْجَاْتُ ظَهري إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لا مَلْجَأَ وَلا مَنْجَى مِنْـكَ إِلاّ إِلَـيْكَ، آمَنْتُ بِكِتابِكَ الذي أَنْزَلْتَ وَبِنَبِـيِّكَ الذي أَرْسَلْتْ.",
                            text: " مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "اللّهُـمَّ قِنـي عَذابَـكَ يَـوْمَ تَبْـعَثُ عِبـادَك.",
                            text: " ثلاث مرات",count: 3,
                            ),
                        ZikrCard(
                            zkr: " سُبْحَانَ اللَّ و الْحَمْـــدُ لِلّه و اللَّهُ أَكْبَــــرْ.ٌ",
                            text: "ثلاث وثلاثون",count: 33,
                            ),
                        ZikrCard(
                            zkr: " يجمع كفّيه قبل النوم ويقرأ فيهما:‏ ” قل هو الله أحد “‏ و ” ‏قل أعوذ برب الفلق “‏ و” ‏قل أعوذ برب الناس‏ “‏ ثمّ ينفث فيهما، ويمسح بهما على رأسه ووجهه وما استطاع من الجسد.",
                            text: " ثلاث مرات", count: 3,
                            ),
                        ZikrCard(
                            zkr: "آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِنْ رُسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ﴿285﴾ لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينٌ",
                            text: "مره واحده",count: 1,
                            ),
                        ZikrCard(
                            zkr: "اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمٌُ",
                            text: "مره واحده",count: 1,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


