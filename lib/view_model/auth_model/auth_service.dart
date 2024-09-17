import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'phone' : ""
      });
    } catch (e) {
      // Handle the error
      print('Error creating user profile: $e');
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    // required String cr,
    // required String vat,
  }) async {
    try {
      // show loading
      Get.snackbar(
        'Loading',
        'please wait',
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        // 'cr': cr,
        // 'vat': vat,
        "addresses": []
      });
    } catch (e) {
      // Handle the error
      Get.snackbar('Error', e.toString(),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

  Future<UserProfile> getUserProfile(String userId) async {
    //  get user email
    var userData = await _firestore.collection('users').doc(userId).get();
    // check if have email
    if (userData.data()!['email'] == null) {
      await _firestore.collection('users').doc(userId).update({
        'email': _auth.currentUser!.email,
      });
      userData = await _firestore.collection('users').doc(userId).get();
    }
    return UserProfile.fromSnapshot(userData);
  }

// get stream of  List of UserProfile by ids
  Stream<List<UserProfile>> getUserProfiles(List<String> userIds) {
    return _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserProfile.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addPhoto(photo, userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({'photo': photo});
    } catch (e) {
      print('Error adding photo: $e');
    }
  }

  Future<void> addAddress({
    required String userId,
    required String address,
    required double lat,
    required double lng,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(
        {
          'addresses': FieldValue.arrayUnion([
            {
              'address': address,
              'lat': lat,
              'lng': lng,
            }
          ])
        },
      );
    } catch (e) {
      // Handle the error
      print('Error adding address: $e');
    }
  }

  // update password
  Future<void> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  // update email
  Future<void> updateEmail(String email) async {
    try {
      await _auth.currentUser!.updateEmail(email);
    } catch (e) {
      print('Error updating email: $e');
    }
  }
  // get admins profiles

  Future<List<UserProfile>> getAdminsProfiles() async {
    //  get user email
    var userData = await _firestore
        .collection('users')
        .where('isAdmin', isEqualTo: true)
        .get();
    return userData.docs.map((doc) => UserProfile.fromSnapshot(doc)).toList();
  }
}
class Address2 {
  final String address;
  final double lat;
  final double lng;
  toMap() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }

  Address2({
    required this.address,
    required this.lat,
    required this.lng,
  });
}
class UserProfile {
  @override
  String toString() {
    return 'UserProfile(name: $name, phone: $phone, cr: $cr, role: $role, vat: $vat, addresses: $addresses, isAdmin: $isAdmin, email: $email)';
  }

  final String? id;
  final String name;
  final String phone;
  final String cr;
  final String? role;
  final String vat;
  final String? photo;
  final bool isAdmin;
  final String? email;
  // to map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'cr': cr,
      'role': role,
      'vat': vat,
      'photo': photo,
      'isAdmin': isAdmin,
      'email': email,
      'addresses': addresses.map((x) => x.toMap()).toList(),
    };
  }

// addressess
  final List<Address2> addresses;

  UserProfile(
      {required this.name,
        required this.phone,
        required this.cr,
        this.photo,
        this.id,
        this.role,
        required this.vat,
        required this.addresses,
        this.email,
        this.isAdmin = false});

  factory UserProfile.fromMap(Map<String, dynamic> map, {String? id}) {
    final isAdmin = (map['isAdmin'] ?? false) || map['role'] == 'admin';
    return UserProfile(
      id: 'id',
      name: map['name'],
      phone: map['phone'],
      role: map['role'],
      email: map['email'],
      cr: map['cr'] ?? '',
      vat: map['vat'] ?? "",
      photo: map['photo'] ?? '',
      addresses: map['addresses'] == null
          ? []
          : List<Address2>.from(
        map['addresses'].map(
              (address) => Address2(
            address: address['address'],
            lat: address['lat'],
            lng: address['lng'],
          ),
        ),
      ),
      isAdmin: isAdmin,
    );
  }
  // from fromSnapshot
  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>,
        id: snapshot.id);
  }
}
class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserProfile> _admins = [];
  List<UserProfile> get admins => _admins;

// singelton
  static final AdminProvider _instance = AdminProvider._internal();
  factory AdminProvider() => _instance;
  AdminProvider._internal() {
    // getAdmins();
  }
  bool isAdmin = false;

  void checkIfAdmin() async {
    isAdmin = false;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userProfile = await AuthService().getUserProfile(user.uid);
      if (userProfile.isAdmin == true || userProfile.role == 'admin') {
        isAdmin = true;
      }
    }

    notifyListeners();
  }

  Future<void> getAdmins() async {
    try {
      final adminsData = await _firestore
          .collection('users')
          .where('isAdmin', isEqualTo: true)
          .get();
      _admins =
          adminsData.docs.map((doc) => UserProfile.fromSnapshot(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error getting admins: $e');
    }
  }
}