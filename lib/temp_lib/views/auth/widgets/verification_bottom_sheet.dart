import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/tabs_screen.dart';

class VerificationBottomSheet extends StatelessWidget {
  const VerificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 35,
          ),
          Image.asset('assets/ilus.png'),
          Text(
            S.of(context).CreateAccountSuccess,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            S
                .of(context)
                .CongratulationYouhavesuccesscreatingaccountWehavesendyouanemailtoverifyyouraccount,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                color: defaultColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Text(
                  S.of(context).Check_Email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const TabsScreen(isLoggedIn: false)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  S.of(context).GotoHomepage,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
