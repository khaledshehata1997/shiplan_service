import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';
import 'package:shiplan_service/temp_lib/controllers/auth_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';
import 'package:shiplan_service/temp_lib/views/cart%20screens/screens/product_details_screen.dart';
import 'package:shiplan_service/temp_lib/views/tabs%20screens/widgets/linear_notification.dart';

class BestSellerWidget extends StatefulWidget {
  const BestSellerWidget(
      {super.key,
      required this.isLoggedIn,
      required this.name,
      required this.image,
      required this.price,
      required this.product});
  final bool isLoggedIn;
  final String name;
  final String image;
  final double price;
  final Product product;

  @override
  State<BestSellerWidget> createState() => _BestSellerWidgetState();
}

class _BestSellerWidgetState extends State<BestSellerWidget> {
  late Image decodedImage;
  @override
  void initState() {
    super.initState();
    decodedImage = Image.memory(
      base64Decode(widget.image),
      fit: BoxFit.cover,
    );
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1, // Ensures a square aspect ratio (1:1)
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FittedBox(
                    fit: BoxFit
                        .cover, // Fills the container while keeping the aspect ratio
                    child: decodedImage,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(width: 15.w),
                Text(
                  textAlign: TextAlign.start,
                  '${widget.price}SAR',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(top: 10.h, end: 10.w),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: SizedBox(
              height: 30.0,
              width: 30.0,
              child: ElevatedButton(
                onPressed: !isLoading
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (widget.isLoggedIn) {
                          if (widget.product.stock == 0) {
                            showTopSnackBar(
                              context,
                              S.of(context).OutOfStock,
                              Icons.check_circle,
                              defaultColor,
                              const Duration(seconds: 4),
                            );
                          } else if (widget.product.optionImages!.isNotEmpty) {
                            showTopSnackBar(
                              context,
                              S.of(context).ChooseOptionPlease,
                              Icons.check_circle,
                              defaultColor,
                              const Duration(seconds: 4),
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProductDetailsScreen(
                                    product: widget.product)));
                          } else {
                            Provider.of<CartController>(context, listen: false)
                                .addProductsToList(widget.product);
                            showTopSnackBar(
                              context,
                              S.of(context).ItemAddedToCart,
                              Icons.check_circle,
                              defaultColor,
                              const Duration(seconds: 4),
                            );
                          }
                        } else {
                          Provider.of<AuthService>(context, listen: false)
                              .showLoginDialog(context);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Center(
                        child: SvgPicture.asset(
                          'assets/shopping-cart.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showTopSnackBar(BuildContext context, String message, IconData icon,
    Color color, Duration duration) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0, // Distance from the top of the screen
      left: 10.0,
      right: 10.0,
      child: Material(
        color: Colors.transparent,
        child: NotificationWithProgressBar(
          message: message,
          icon: icon,
          color: color,
          duration: duration,
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  // Remove the overlay after the duration completes
  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}
