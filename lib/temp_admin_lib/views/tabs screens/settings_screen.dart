// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/controller/auth_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/shipping_charge_controller.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_shipping_charge.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_support_num_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceAdmin>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              if (authService.isUserLoggedIn) {
                final shippingProvider =
                    Provider.of<ShippingChargeControllerAdmin>(context, listen: false);
                await shippingProvider.fetchShippingCharge();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddShippingCharge(
                      value: shippingProvider.shippingCharge,
                    ),
                  ),
                );
              } else {
                authService.showLoginDialog(context);
              }
            },
            leading: const Icon(Icons.money, color: Colors.black),
            title: const Text(
              'Shipping Charge',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ListTile(
            onTap: () async {
              if (authService.isUserLoggedIn) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddSupportNumScreen(),
                  ),
                );
              } else {
                authService.showLoginDialog(context);
              }
            },
            leading: const Icon(Icons.mobile_friendly, color: Colors.black), // Changed to black
            title: const Text(
              'Support number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black, // Changed to black
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
