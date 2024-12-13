import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_brand_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_category_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_coupon_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_product_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/add_support_num_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/advertisments_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/auth_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/dashboard_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/image_picker_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/notification_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/orders_controller.dart';
import 'package:shiplan_service/temp_admin_lib/controller/shipping_charge_controller.dart';
import 'package:shiplan_service/temp_admin_lib/firebase_options.dart';
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_admin_lib/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImagePickerController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddCategoryController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthServiceAdmin(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddBrandController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddProductController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdvertismentsController(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersControllerAdmin(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddCouponController(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ShippingChargeControllerAdmin(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddSupportNumController(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdImageController(),
        ),
      ],
      child: Consumer<NotificationController>(
        builder: (context, notifiProvider, _) {
          notifiProvider.initializeFCM(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
              fontFamily: 'Manrope',
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
