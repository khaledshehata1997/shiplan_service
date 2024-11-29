import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/content%20screens/search_result_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/filter_bottom_sheet.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.searchController});
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const SizedBox(
                  height: 3,
                ),
                TextField(
                  controller: searchController,
                  cursorColor: Colors.black,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => SearchResultScreen(
                                searchPrompt: value,
                                isBrandSearched: false,
                              )));
                    }
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: GestureDetector(
                        onTap: () {
                          if (searchController.text.trim().isNotEmpty) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => SearchResultScreen(
                                      isBrandSearched: false,
                                      searchPrompt: searchController.text,
                                    )));
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/search-normal.svg'),
                            const SizedBox(
                              height: 6,
                            )
                          ],
                        ),
                      ),
                      hintText: S.of(context).search,
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.4))),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor:
                  themeProvider.isDarkMode ? darkMoodColor : Colors.white,
              showDragHandle: true,
              context: context,
              builder: (context) {
                return Container(
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? darkMoodColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: const FilterBottomSheet());
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: defaultColor,
            ),
            child: Center(
              child: SvgPicture.asset('assets/sort.svg'),
            ),
          ),
        ),
      ],
    );
  }
}
