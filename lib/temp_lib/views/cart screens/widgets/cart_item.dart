import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shiplan_service/temp_lib/controllers/cart_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/lang_controller.dart';
import 'package:shiplan_service/temp_lib/controllers/product_controller.dart';
import 'package:shiplan_service/temp_lib/models/product.dart';

class CartItem extends StatefulWidget {
  const CartItem(
      {super.key,
      required this.isCheckout,
      required this.product,
      required this.onDelete});
  final bool isCheckout;
  final Product product;
  final VoidCallback onDelete;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int _counter;
  double itemPrice = 0;
  // int? selectedOptionIndex;
  late Image decodedImage;

  @override
  void initState() {
    decodedImage = Image.memory(
      base64Decode(widget.product.image),
      fit: BoxFit.fill,
    );
    itemPrice = widget.product.price * widget.product.quantityInCart;
    _counter = widget.product.quantityInCart;
    // selectedOptionIndex = Provider.of<ProductController>(context,listen: false).selectedOptionIndex;
    super.initState();
  }

  void _incrementCounter() {
    if (_counter < widget.product.stock!) {
      setState(() {
        _counter++;
      });
      Provider.of<CartController>(context, listen: false)
          .setNewTotalPrice(widget.product.price, true);
      Provider.of<ProductController>(context, listen: false)
          .updateQuantityInCart(widget.product, 'add');
      setItemPrice();
    }
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        Provider.of<CartController>(context, listen: false)
            .setNewTotalPrice(widget.product.price, false);
        Provider.of<ProductController>(context, listen: false)
            .updateQuantityInCart(widget.product, 'sub');
      }
    });

    setItemPrice();
  }

  void setItemPrice() {
    itemPrice = widget.product.price * _counter;
  }

  @override
  Widget build(BuildContext context) {
    final langController = Provider.of<LangController>(context, listen: false);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 90,
                width: 90,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200,
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
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langController.isArabic
                        ? widget.product.nameAr
                        : widget.product.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${itemPrice}IQD',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  widget.product.colors.isNotEmpty
                      ? CircleAvatar(
                          backgroundColor: Color(widget.product.selectedColor!),
                          radius: 20,
                        )
                      : const SizedBox(),
                  // widget.product.stock! > 0 ? Text('QTY: ${widget.product.stock}') : const Text('out of stock'),
                  const SizedBox(height: 12),
                ],
              ),
            ]),
            Column(
              children: [
                !widget.isCheckout
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 60,
                          ),
                          GestureDetector(
                              onTap: widget.onDelete,
                              child: const Icon(Icons.delete_outline)),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 30,
                ),
                if (!widget.isCheckout)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _decrementCounter,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: langController.isArabic
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Center(
                            child: Icon(Icons.remove),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Center(
                          child: Text('$_counter'),
                        ),
                      ),
                      GestureDetector(
                        onTap: _incrementCounter,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: langController.isArabic
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Center(
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(width: 90),
                const SizedBox(height: 10)
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Divider(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
