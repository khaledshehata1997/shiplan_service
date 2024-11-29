// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';

class LangScreen extends StatefulWidget {
  const LangScreen({super.key});

  @override
  State<LangScreen> createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  int? _selectedLang;
  int? fetchedLang;

  @override
  void initState() {
    fetchLangNumber();
    super.initState();
  }

  Future<void> fetchLangNumber() async {
    final langController = Provider.of<LangController>(context, listen: false);
    await langController.loadLocale();
    fetchedLang = langController.selectedLang;
    setState(() {
      _selectedLang = fetchedLang!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final langController = Provider.of<LangController>(context, listen: false);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode ? darkMoodColor : Colors.white,
        title: Text(
          S.of(context).language,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioListTile(
              activeColor: defaultColor,
              contentPadding: const EdgeInsets.all(0),
              value: 0,
              groupValue: _selectedLang,
              onChanged: (int? value) {
                setState(() {
                  _selectedLang = value!;
                });
                langController.setLocale('ar', 0);
              },
              controlAffinity: ListTileControlAffinity.trailing,
              title: Row(
                children: [
                  Image.asset(
                    'assets/iraq.png',
                    width: 25,
                  ),
                  const SizedBox(width: 10),
                  Text(S.of(context).arabic),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade200),
            RadioListTile(
              activeColor: defaultColor,
              contentPadding: const EdgeInsets.all(0),
              value: 1,
              groupValue: _selectedLang,
              onChanged: (int? value) {
                setState(() {
                  _selectedLang = value!;
                });
                langController.setLocale('en', 1);
              },
              controlAffinity: ListTileControlAffinity.trailing,
              title: Row(
                children: [
                  SvgPicture.asset('assets/england_svgrepo.com.svg'),
                  const SizedBox(width: 10),
                  Text(S.of(context).English),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade200),
          ],
        ),
      ),
    );
  }
}
