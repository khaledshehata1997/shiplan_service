import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:shiplan_service/temp_admin_lib/views/actions%20screens/add_advertisment_screen.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/brand_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/category_contoller.dart';
import 'package:shiplan_service/temp_lib/controllers/coupon_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/dark_mode_service.dart';
import 'package:shiplan_service/temp_lib/controllers/discounts_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/favorites_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/oreders_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/shipping_charge.dart';
import 'package:shiplan_service/temp_lib/controllers/zain_cash_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/views/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TempApp());
}

class TempApp extends StatelessWidget {
  const TempApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => BrandController()),
        ChangeNotifierProvider(create: (_) => DiscountsController()),
        ChangeNotifierProvider(create: (_) => ShippingChargeController()),
        ChangeNotifierProvider(create: (_) => ZainCashController()),
        ChangeNotifierProvider(create: (_) => FavoritesController()),
        ChangeNotifierProvider(create: (_) => OrdersController()),
        ChangeNotifierProvider(create: (_) => LangController()),
        ChangeNotifierProvider(create: (_) => CouponController()),
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
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final langController = Provider.of<LangController>(context);
              langController.loadLocale();
              return MaterialApp(
                locale: langController.locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                theme: themeProvider.getTheme,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
