import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easyfit_app/helper/constants/constants.dart';
import 'package:easyfit_app/screens/home/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../../model/cart/cart_model.dart';
import '../constants/constants.dart';
import '../preference/preference_manager.dart';

class StateController extends GetxController {
  Dao? myDao;

  StateController({this.myDao});

  PreferenceManager? manager;

  var isAppClosed = false;
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var hideNavbar = false.obs;
  var showPlan = false.obs;
  var hasInternetAccess = true.obs;

  var currentUser; //FirebaseAuth.instance.currentUser;
  var mealsLeft = "".obs;

  var tabController = PersistentTabController(initialIndex: 0);

  var productsData = "".obs;
  var onboardingIndex = 0.obs;

  var userData = {}.obs;
  var carts = [].obs;
  var orders = [].obs;
  var menus = [].obs;
  var meals = [].obs;
  var featuredMeal = {}.obs;
  var planSetup = {};
  var searchData = [].obs;

  RxDouble subTotalPrice = 0.0.obs;
  var deliveryFee = 0.obs;
  var totalAmount = 0.0.obs;
  var planGrandTotal = 0.0.obs;
  var planCheckoutPrice = 0.0.obs;
  RxInt itemQuantity = 1.obs;
  Map deliveryInfo = {};
  var advancedCartList = [].obs;
  var monCartList = [].obs;
  var tueCartList = [].obs;
  var wedCartList = [].obs;
  var thuCartList = [].obs;
  var friCartList = [].obs;
  var satCartList = [].obs;
  var sunCartList = [].obs;

  RxInt cartLength = 0.obs;
  RxInt mealsCount = 0.obs;

  var noPlanDeliveryDate = "";

  ScrollController transactionsScrollController = ScrollController();
  ScrollController messagesScrollController = ScrollController();

  var accessToken = "".obs;
  String _token = "";
  RxString dbItem = 'Awaiting data'.obs;

  @override
  void onInit() async {
    super.onInit();
    // manager = PreferenceManager()
    initDao();

    // if (_token.isNotEmpty) {}
  }

  Future<void> initDao() async {
    // instantiate Dao only if null (i.e. not supplied in constructor)
    myDao = await Dao.createAsync();
    dbItem.value = myDao!.dbValue;
  }

  Widget currentScreen = Home();

  var currentPage = "Home";
  List<String> pageKeys = [
    "Home",
    "Categories",
    "Promos",
    "Services",
    "Account"
  ];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Categories": GlobalKey<NavigatorState>(),
    "Promos": GlobalKey<NavigatorState>(),
    "Services": GlobalKey<NavigatorState>(),
    "Account": GlobalKey<NavigatorState>(),
  };

  var selectedIndex = 0.obs;

  setCart(var value) {
    carts = value;
  }

  setUserData(var value) {
    userData.value = value;
  }

  setOrders(var value) {
    orders = value;
  }

  clearMeals() async {}

  savePlan(var data) async {
    planSetup = data;
    try {
      //Remove all meals first

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveNoPlanDeliveryDate(var date) {
    noPlanDeliveryDate = date;
  }

  setMenusData(var data) {
    menus.value = data;
  }

  setSearchData(var data) {
    searchData.value.add(data);
  }

  setFeaturedMeal(var data) {
    featuredMeal.value = data;
  }

  setMealsData(var data) {
    meals.value = data;
  }

  setsubTotalPrice(var value) {
    subTotalPrice.value = value;
  }

  setDeliveryFee(fee) {
    deliveryFee.value = 0;
    deliveryFee.value = fee;
  }

  setQuantity(var quantity) {
    itemQuantity.value = quantity;
  }

  setMealsCount(int quantity) {
    mealsCount.value += quantity;
  }

  setTotalAmount(totalAmt, delivery) {
    // totalAmount.value = 0.0;
    // Future.delayed(const Duration(milliseconds: 400), () {
    totalAmount.value = totalAmt + delivery;
    // });
  }

  setPlanTotalAmount(var value) {
    planGrandTotal.value = value;
    // totalAmount.value = value;
  }

  setPlanCheckoutPrice(var price) {
    planCheckoutPrice.value = price;
  }

  setCartLength(int length) {
    cartLength.value = length;
  }

  setDeliveryInfo(Map map) {
    deliveryInfo = map;
  }

  addProductToCart(userId, data, int quan) async {}

  addMealsInfo(userId, payload, discount, assignedMeals) async {}

  addMealToCart(userId, data, int quan) async {}

  // void removeCartItem(var cartItem, userId) {
  //   FirebaseFirestore.instance.collection("users").doc("$userId").update({
  //     "cart": FieldValue.arrayRemove([cartItem])
  //   });
  // }

  // void emptyCart(var cartItems, userId) {
  //   cartItems.forEach((element) {
  //     FirebaseFirestore.instance.collection("users").doc("$userId").update({
  //       "cart": FieldValue.arrayRemove([element])
  //     });
  //   });
  // }

  void removeCartItem(cartItem, userId) {}

  void emptyCart(var cartItems) {}

  changeCartTotalPrice(var data) {
    subTotalPrice.value = 0.0;
    cartLength.value = 0;
    List<dynamic> _list = jsonDecode(data);
    setDeliveryFee(_list.length);
    for (var elem in _list) {
      subTotalPrice.value += elem['cost'];
    }
    setCartLength(_list.length);

    // deliveryFee.value = itemQuantity.value * 1000;
    setTotalAmount(subTotalPrice.value, deliveryFee.value);
  }

  void setShowPlan(bool state) {
    showPlan.value = state;
  }

  void setProductsData(String state) {
    productsData.value = state;
  }

  void jumpTo(int pos) {
    tabController.jumpToTab(pos);
  }

  void setLoading(bool state) {
    isLoading.value = state;
  }

  void resetAll() {}

  @override
  void onClose() {
    super.onClose();
    transactionsScrollController.dispose();
    messagesScrollController.dispose();
  }
}
