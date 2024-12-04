// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Top Brand`
  String get topBrand {
    return Intl.message(
      'Top Brand',
      name: 'topBrand',
      desc: '',
      args: [],
    );
  }

  /// `view All`
  String get viewAll {
    return Intl.message(
      'view All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs {
    return Intl.message(
      'Blogs',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `Best Seller Products`
  String get bestSellerProducts {
    return Intl.message(
      'Best Seller Products',
      name: 'bestSellerProducts',
      desc: '',
      args: [],
    );
  }

  /// `All Products`
  String get allProducts {
    return Intl.message(
      'All Products',
      name: 'allProducts',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personalInfo {
    return Intl.message(
      'Personal Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Your Orders`
  String get yourOrders {
    return Intl.message(
      'Your Orders',
      name: 'yourOrders',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Login to Your Account`
  String get logintoyourAccount {
    return Intl.message(
      'Login to Your Account',
      name: 'logintoyourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please login to access your Shiny account`
  String get pleaseLogin {
    return Intl.message(
      'Please login to access your Shiny account',
      name: 'pleaseLogin',
      desc: '',
      args: [],
    );
  }

  /// `Email address or phone number`
  String get emailOrPhone {
    return Intl.message(
      'Email address or phone number',
      name: 'emailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email or phone number`
  String get enterEmailOrPhoneNumber {
    return Intl.message(
      'Enter your Email or phone number',
      name: 'enterEmailOrPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get forgetPassword {
    return Intl.message(
      'Forget Password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or login using`
  String get OrLogin {
    return Intl.message(
      'Or login using',
      name: 'OrLogin',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get createNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please create account first before enjoy the features`
  String get pleaseCreateAccount {
    return Intl.message(
      'Please create account first before enjoy the features',
      name: 'pleaseCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message(
      'Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get emailAddress {
    return Intl.message(
      'Email address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your username`
  String get enterYouruserName {
    return Intl.message(
      'Enter your username',
      name: 'enterYouruserName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAcc {
    return Intl.message(
      'Create Account',
      name: 'createAcc',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message(
      'Light Mode',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `No items Selected`
  String get noItemsSelected {
    return Intl.message(
      'No items Selected',
      name: 'noItemsSelected',
      desc: '',
      args: [],
    );
  }

  /// `Update Email`
  String get updateEmail {
    return Intl.message(
      'Update Email',
      name: 'updateEmail',
      desc: '',
      args: [],
    );
  }

  /// `Update Phone Number`
  String get updatePhoneNumber {
    return Intl.message(
      'Update Phone Number',
      name: 'updatePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get updatePass {
    return Intl.message(
      'Update Password',
      name: 'updatePass',
      desc: '',
      args: [],
    );
  }

  /// `Save image`
  String get saveImage {
    return Intl.message(
      'Save image',
      name: 'saveImage',
      desc: '',
      args: [],
    );
  }

  /// `Apply Coupon`
  String get applyCoupon {
    return Intl.message(
      'Apply Coupon',
      name: 'applyCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Price Details`
  String get priceDetails {
    return Intl.message(
      'Price Details',
      name: 'priceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Item Total`
  String get itemTotal {
    return Intl.message(
      'Item Total',
      name: 'itemTotal',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Charge`
  String get shippingCharge {
    return Intl.message(
      'Shipping Charge',
      name: 'shippingCharge',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Porceed to Buy`
  String get porceedToBuy {
    return Intl.message(
      'Porceed to Buy',
      name: 'porceedToBuy',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Zain Cash`
  String get zainCash {
    return Intl.message(
      'Zain Cash',
      name: 'zainCash',
      desc: '',
      args: [],
    );
  }

  /// `Cash on Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message(
      'Pay Now',
      name: 'payNow',
      desc: '',
      args: [],
    );
  }

  /// `No Orders Available`
  String get noOrdersAvailable {
    return Intl.message(
      'No Orders Available',
      name: 'noOrdersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get trackOrder {
    return Intl.message(
      'Track Order',
      name: 'trackOrder',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Packing`
  String get packing {
    return Intl.message(
      'Packing',
      name: 'packing',
      desc: '',
      args: [],
    );
  }

  /// `Order Place Successfully`
  String get orderPlaceSuccessfully {
    return Intl.message(
      'Order Place Successfully',
      name: 'orderPlaceSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully made order`
  String get youHaveSuccessfullyMadeOrder {
    return Intl.message(
      'You have successfully made order',
      name: 'youHaveSuccessfullyMadeOrder',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message(
      'English',
      name: 'English',
      desc: '',
      args: [],
    );
  }

  /// `No favorites yet!`
  String get noFavYet {
    return Intl.message(
      'No favorites yet!',
      name: 'noFavYet',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Address`
  String get enterYourAddress {
    return Intl.message(
      'Enter your Address',
      name: 'enterYourAddress',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get AddToCart {
    return Intl.message(
      'Add to Cart',
      name: 'AddToCart',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get Exit {
    return Intl.message(
      'Exit',
      name: 'Exit',
      desc: '',
      args: [],
    );
  }

  /// `transaction failed!`
  String get transactionfailed {
    return Intl.message(
      'transaction failed!',
      name: 'transactionfailed',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get Pleasetryagain {
    return Intl.message(
      'Please try again',
      name: 'Pleasetryagain',
      desc: '',
      args: [],
    );
  }

  /// `Item added to Cart!`
  String get ItemAddedToCart {
    return Intl.message(
      'Item added to Cart!',
      name: 'ItemAddedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Choose Option Please`
  String get ChooseOptionPlease {
    return Intl.message(
      'Choose Option Please',
      name: 'ChooseOptionPlease',
      desc: '',
      args: [],
    );
  }

  /// `Choose Colors`
  String get ChooseColors {
    return Intl.message(
      'Choose Colors',
      name: 'ChooseColors',
      desc: '',
      args: [],
    );
  }

  /// `this product is out of stock`
  String get thisproductisoutofstock {
    return Intl.message(
      'this product is out of stock',
      name: 'thisproductisoutofstock',
      desc: '',
      args: [],
    );
  }

  /// `coupon applied`
  String get couponApplied {
    return Intl.message(
      'coupon applied',
      name: 'couponApplied',
      desc: '',
      args: [],
    );
  }

  /// `Coupon usage limit reached`
  String get Couponusagelimitreached {
    return Intl.message(
      'Coupon usage limit reached',
      name: 'Couponusagelimitreached',
      desc: '',
      args: [],
    );
  }

  /// `Coupon has expired`
  String get Couponhasexpired {
    return Intl.message(
      'Coupon has expired',
      name: 'Couponhasexpired',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Coupon is invalid`
  String get Couponisinvalid {
    return Intl.message(
      'Coupon is invalid',
      name: 'Couponisinvalid',
      desc: '',
      args: [],
    );
  }

  /// `No brands found`
  String get nobrandsfound {
    return Intl.message(
      'No brands found',
      name: 'nobrandsfound',
      desc: '',
      args: [],
    );
  }

  /// `No Notifications Found`
  String get NoNotificationsFound {
    return Intl.message(
      'No Notifications Found',
      name: 'NoNotificationsFound',
      desc: '',
      args: [],
    );
  }

  /// `enter coupon`
  String get enterCoupon {
    return Intl.message(
      'enter coupon',
      name: 'enterCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filter`
  String get ApplyFilter {
    return Intl.message(
      'Apply Filter',
      name: 'ApplyFilter',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get Reset {
    return Intl.message(
      'Reset',
      name: 'Reset',
      desc: '',
      args: [],
    );
  }

  /// `Selected range`
  String get Selectedrange {
    return Intl.message(
      'Selected range',
      name: 'Selectedrange',
      desc: '',
      args: [],
    );
  }

  /// `qty`
  String get qty {
    return Intl.message(
      'qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Out Of Stock!`
  String get OutOfStock {
    return Intl.message(
      'Out Of Stock!',
      name: 'OutOfStock',
      desc: '',
      args: [],
    );
  }

  /// `You have to login first`
  String get Youhavetologinfirst {
    return Intl.message(
      'You have to login first',
      name: 'Youhavetologinfirst',
      desc: '',
      args: [],
    );
  }

  /// `delete Account`
  String get deleteAccount {
    return Intl.message(
      'delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure You Want To Delete Your Account?`
  String get areYouSureYouWantToDeleteYourAccount {
    return Intl.message(
      'Are You Sure You Want To Delete Your Account?',
      name: 'areYouSureYouWantToDeleteYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete Account`
  String get confirmDeleteAccount {
    return Intl.message(
      'Confirm Delete Account',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Timeline`
  String get timeline {
    return Intl.message(
      'Timeline',
      name: 'timeline',
      desc: '',
      args: [],
    );
  }

  /// `Order Id`
  String get Order_Id {
    return Intl.message(
      'Order Id',
      name: 'Order_Id',
      desc: '',
      args: [],
    );
  }

  /// `Go to home`
  String get Go_to_home {
    return Intl.message(
      'Go to home',
      name: 'Go_to_home',
      desc: '',
      args: [],
    );
  }

  /// `delivery`
  String get delivery {
    return Intl.message(
      'delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get Completed {
    return Intl.message(
      'Completed',
      name: 'Completed',
      desc: '',
      args: [],
    );
  }

  /// `Your order is on his way`
  String get Your_order_is_on_his_way {
    return Intl.message(
      'Your order is on his way',
      name: 'Your_order_is_on_his_way',
      desc: '',
      args: [],
    );
  }

  /// `Your order is delivered`
  String get Your_order_is_delivered {
    return Intl.message(
      'Your order is delivered',
      name: 'Your_order_is_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get Contact_us {
    return Intl.message(
      'Contact us',
      name: 'Contact_us',
      desc: '',
      args: [],
    );
  }

  /// `System - Insufficient Credit Balance in Wallet Account`
  String get insufficient_credit_Balance {
    return Intl.message(
      'System - Insufficient Credit Balance in Wallet Account',
      name: 'insufficient_credit_Balance',
      desc: '',
      args: [],
    );
  }

  /// `OTP number error`
  String get OTP_number_error {
    return Intl.message(
      'OTP number error',
      name: 'OTP_number_error',
      desc: '',
      args: [],
    );
  }

  /// `Phone number or Pin is false`
  String get verify_phone_and_pin {
    return Intl.message(
      'Phone number or Pin is false',
      name: 'verify_phone_and_pin',
      desc: '',
      args: [],
    );
  }

  /// `Transaction failed`
  String get transaction_failed {
    return Intl.message(
      'Transaction failed',
      name: 'transaction_failed',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Email updated successfully`
  String get email_updated_successfully {
    return Intl.message(
      'Email updated successfully',
      name: 'email_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update email`
  String get failed_to_update_email {
    return Intl.message(
      'Failed to update email',
      name: 'failed_to_update_email',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get password_updated_successfully {
    return Intl.message(
      'Password updated successfully',
      name: 'password_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update password`
  String get failed_to_update_password {
    return Intl.message(
      'Failed to update password',
      name: 'failed_to_update_password',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number is not valid`
  String get phone_number_is_not_valid {
    return Intl.message(
      'Phone Number is not valid',
      name: 'phone_number_is_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `Phone number updated successfully`
  String get phone_number_updated_successfully {
    return Intl.message(
      'Phone number updated successfully',
      name: 'phone_number_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update phone number`
  String get failed_to_update_phone_number {
    return Intl.message(
      'Failed to update phone number',
      name: 'failed_to_update_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email or phone number`
  String get please_enter_a_valid_email_or_phone_number {
    return Intl.message(
      'Please enter a valid email or phone number',
      name: 'please_enter_a_valid_email_or_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `address and phone number are required`
  String get address_and_phone_number_are_required {
    return Intl.message(
      'address and phone number are required',
      name: 'address_and_phone_number_are_required',
      desc: '',
      args: [],
    );
  }

  /// `You have to login first`
  String get you_have_to_login_first {
    return Intl.message(
      'You have to login first',
      name: 'you_have_to_login_first',
      desc: '',
      args: [],
    );
  }

  /// `You can not buy with less than 1000`
  String get you_cant_buy_with_less_than_1000 {
    return Intl.message(
      'You can not buy with less than 1000',
      name: 'you_cant_buy_with_less_than_1000',
      desc: '',
      args: [],
    );
  }

  /// `No support available now`
  String get no_support_available_now {
    return Intl.message(
      'No support available now',
      name: 'no_support_available_now',
      desc: '',
      args: [],
    );
  }

  /// `Login Successful`
  String get Login_Successful {
    return Intl.message(
      'Login Successful',
      name: 'Login_Successful',
      desc: '',
      args: [],
    );
  }

  /// `Verification email sent. Please check your inbox.`
  String get Verification_email_sent_Please_check_your_inbox {
    return Intl.message(
      'Verification email sent. Please check your inbox.',
      name: 'Verification_email_sent_Please_check_your_inbox',
      desc: '',
      args: [],
    );
  }

  /// `Could not send verification email. Try again later.`
  String get Could_not_send_verification_email_Try_again_later {
    return Intl.message(
      'Could not send verification email. Try again later.',
      name: 'Could_not_send_verification_email_Try_again_later',
      desc: '',
      args: [],
    );
  }

  /// `Resend Email`
  String get Resend_Email {
    return Intl.message(
      'Resend Email',
      name: 'Resend_Email',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get Something_went_wrong {
    return Intl.message(
      'Something went wrong!',
      name: 'Something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Canceled`
  String get Sign_In_Canceled {
    return Intl.message(
      'Sign In Canceled',
      name: 'Sign_In_Canceled',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get USer_Not_Found {
    return Intl.message(
      'User not found',
      name: 'USer_Not_Found',
      desc: '',
      args: [],
    );
  }

  /// `Password is incorrect`
  String get Password_is_incorrect {
    return Intl.message(
      'Password is incorrect',
      name: 'Password_is_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again later.`
  String get An_error_occurred_Please_try_again_later {
    return Intl.message(
      'An error occurred. Please try again later.',
      name: 'An_error_occurred_Please_try_again_later',
      desc: '',
      args: [],
    );
  }

  /// `Login Required`
  String get Login_required {
    return Intl.message(
      'Login Required',
      name: 'Login_required',
      desc: '',
      args: [],
    );
  }

  /// `You need to log in to add items to your cart.`
  String get You_need_to_log_in_to_add_items_to_your_cart {
    return Intl.message(
      'You need to log in to add items to your cart.',
      name: 'You_need_to_log_in_to_add_items_to_your_cart',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get Close {
    return Intl.message(
      'Close',
      name: 'Close',
      desc: '',
      args: [],
    );
  }

  /// `Please fill this field`
  String get Pleasefillthis_field {
    return Intl.message(
      'Please fill this field',
      name: 'Pleasefillthis_field',
      desc: '',
      args: [],
    );
  }

  /// `Create Account Success`
  String get CreateAccountSuccess {
    return Intl.message(
      'Create Account Success',
      name: 'CreateAccountSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Congratulation! You have success creating account. We have send you an email to verify your account.`
  String
      get CongratulationYouhavesuccesscreatingaccountWehavesendyouanemailtoverifyyouraccount {
    return Intl.message(
      'Congratulation! You have success creating account. We have send you an email to verify your account.',
      name:
          'CongratulationYouhavesuccesscreatingaccountWehavesendyouanemailtoverifyyouraccount',
      desc: '',
      args: [],
    );
  }

  /// `Check Email!`
  String get Check_Email {
    return Intl.message(
      'Check Email!',
      name: 'Check_Email',
      desc: '',
      args: [],
    );
  }

  /// `Go to Homepage`
  String get GotoHomepage {
    return Intl.message(
      'Go to Homepage',
      name: 'GotoHomepage',
      desc: '',
      args: [],
    );
  }

  /// `This Order is not available`
  String get thisorderisnotavailable {
    return Intl.message(
      'This Order is not available',
      name: 'thisorderisnotavailable',
      desc: '',
      args: [],
    );
  }

  /// `No Categories available`
  String get NobeautyServiceavailable {
    return Intl.message(
      'No Categories available',
      name: 'NobeautyServiceavailable',
      desc: '',
      args: [],
    );
  }

  /// `result`
  String get result {
    return Intl.message(
      'result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `there is no result for this search`
  String get thereisnobrandforthissearch {
    return Intl.message(
      'there is no result for this search',
      name: 'thereisnobrandforthissearch',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Areyousureyouwanttodeleteyouraccount?Thisactioncannotbeundone' key

  /// `No Products for this Category`
  String get NoProductsforthisCategory {
    return Intl.message(
      'No Products for this Category',
      name: 'NoProductsforthisCategory',
      desc: '',
      args: [],
    );
  }

  /// `No Products for this Brand`
  String get NoProductsforthisBrand {
    return Intl.message(
      'No Products for this Brand',
      name: 'NoProductsforthisBrand',
      desc: '',
      args: [],
    );
  }

  /// `refunded`
  String get refunded {
    return Intl.message(
      'refunded',
      name: 'refunded',
      desc: '',
      args: [],
    );
  }

  /// `System - Insufficient Credit Balance in Wallet Account`
  String get SystemInsufficientCreditBalanceinWalletAccount {
    return Intl.message(
      'System - Insufficient Credit Balance in Wallet Account',
      name: 'SystemInsufficientCreditBalanceinWalletAccount',
      desc: '',
      args: [],
    );
  }

  /// `The email address is already in use by another account.`
  String get theEmailIsAlreadyInUse {
    return Intl.message(
      'The email address is already in use by another account.',
      name: 'theEmailIsAlreadyInUse',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
