import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/videos_list.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/screens/youtube_player.dart';

class ShortVideosScreen extends StatefulWidget {
  const ShortVideosScreen({super.key});

  @override
  State<ShortVideosScreen> createState() => _ShortVideosScreenState();
}

class _ShortVideosScreenState extends State<ShortVideosScreen> {
  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).shortVideos),
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      ),
      body: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => VideoPreview(
                        initialVideoId: videos[index]["videoID"].toString(),
                      )));
            },
            child: Container(
              width: 390.w,
              height: 150.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        offset: const Offset(0, 0),
                        blurRadius: 15)
                  ],
                  image: DecorationImage(
                      image: NetworkImage(
                          videos[index]["thumbinalURL"].toString()),
                      fit: BoxFit.fill)),
              child: const Center(
                  child: Icon(
                Icons.play_circle,
                color: Colors.white,
                size: 30,
              )),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10.h);
        },
        itemCount: videos.length,
      ),
    );
  }
}
