import 'dart:convert';
import 'dart:io';

import 'package:data_extra_app/helper/constants/constants.dart';
import 'package:data_extra_app/helper/service/api_service.dart';
import 'package:data_extra_app/main.dart';
import 'package:data_extra_app/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateController extends GetxController {
  Dao? myDao;

  StateController({this.myDao});

  var isAppClosed = false;
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var hideNavbar = false.obs;
  var hasInternetAccess = true.obs;
  var airtimeCashData = [].obs;
  var transactions = [].obs;
  var recentTransactions = [].obs;
  var hasMoreTransactions = false.obs;
  var hasMoreNotifications = false.obs;
  var hasMoreInvites = false.obs;
  var transactionCurrentPage = 0.obs;

  var emptyLogic = "".obs;

  var products = [].obs;
  var internetData = {}.obs;
  var airtimeData = {}.obs;
  var electricityData = {}.obs;
  var cableData = {}.obs;
  var unreadNotifications = 0.obs;
  var isSpinning = false.obs;

  var selectedDataProvider = {}.obs;
  var selectedDataPlan = {}.obs;
  var selectedDataPlanAmount = 0.obs;
  var selectedAirtimeProvider = {}.obs;
  var selectedElectricityProvider = {}.obs;
  var selectedTelevisionProvider = {}.obs;
  var selectedTelevisionPlan = {}.obs;

  var mynotifications = [].obs;
  var navColor = Constants.primaryColor.obs;
  var userData = {}.obs;

  var airtimeSwapData = [].obs;
  var airtimeSwapRate = "".obs;
  var airtimeSwapNumber = "".obs;
  var airtimeSwapResultantAmt = "0.0".obs;

  var discountAmount = 0.0.obs;
  var percentDiscount = "".obs;

  ScrollController transactionsScrollController = ScrollController();
  ScrollController messagesScrollController = ScrollController();

  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  var showForcedDialog = false.obs;
  var showInfoUpdateDialog = false.obs;
  var accessToken = "".obs;
  String _token = "";
  RxString appVersion = "2.0".obs;
  RxString androidAppUrl = "".obs;

  RxString dbItem = 'Awaiting data'.obs;

  var tabController = PersistentTabController(initialIndex: 0);

  PackageInfo? packageInfo;

  // init() async {
  //   packageInfo = await PackageInfo.fromPlatform();
  // }

  getProducts() async {
    try {
      final response = await APIService().getProducts();
      debugPrint("PRODUCT RESP:: ${response.body}");
      setHasInternet(true);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        // ProductResponse body = ProductResponse.fromJson(map);
        setProductData(map['data']);

        map['data']?.forEach((elem) => {
              if (elem['name'].toString().toLowerCase() == "airtime")
                {airtimeData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "data")
                {internetData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "electricity")
                {electricityData.value = elem}
              else if (elem['name'].toString().toLowerCase() == "cable_tv")
                {cableData.value = elem}
            });
      }
    } on SocketException {
      Constants.toast("No Internet Connection!");
      hasInternetAccess.value = false;
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  updateMobile() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
      final response = await APIService().updateMobile();
      debugPrint("UPDATE MOBILE RESPONSE ::: ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        showForcedDialog.value = map['data']['should_update'];
        androidAppUrl.value = map['data']['andriod_url'];
        int latestBuildNum = int.parse(
            "${map['data']['lastest__andriod_mobile_app_build_number']}");
        if (latestBuildNum > int.parse("${packageInfo?.buildNumber}")) {
          showInfoUpdateDialog.value = true;
        } else {
          showInfoUpdateDialog.value = false;
        }
      }
      debugPrint("APP BUILD NUMBER INFO ::: ${packageInfo?.buildNumber}");
      debugPrint("APP VERSION INFO ::: ${packageInfo?.version}");
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "${packageInfo?.version}";
    // print("PACKAGE INFO IS ${packageInfo?.version}");
    initDao();

    updateMobile();
    // Get products
    try {
      //Fetch user data
      final _prefs = await SharedPreferences.getInstance();
      _token = _prefs.getString("accessToken") ?? "";
      // bool _isAuthenticated = prefs.getBool("loggedIn") ?? false;

      if (_token.isNotEmpty) {
        APIService().getProfile(_token).then((value) {
          // print("STATE GET PROFILE >>> ${value.body}");
          Map<String, dynamic> data = jsonDecode(value.body);
          userData.value = data['data'];
          _prefs.setString("user", jsonEncode(data['data']));

          //Update preference here
        }).catchError((onError) {
          debugPrint("STATE GET PROFILE ERROR >>> $onError");
          if (onError.toString().contains("rk is unreachable")) {
            hasInternetAccess.value = false;
          }
        });
        hasInternetAccess.value = true;
        paginateTransaction(_token);
      }
    } on SocketException {
      //No internet here
      hasInternetAccess.value = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> initDao() async {
    // instantiate Dao only if null (i.e. not supplied in constructor)
    myDao = await Dao.createAsync();
    dbItem.value = myDao!.dbValue;
  }

  void paginateTransaction(String accessToken) {
    transactionsScrollController.addListener(() {
      if (transactionsScrollController.position.pixels ==
          transactionsScrollController.position.maxScrollExtent) {
        // print("reached end");

        //Now load more items
        if (hasMoreTransactions.value) {
          setSpinning(true);
          transactionCurrentPage.value++;
          Future.delayed(const Duration(seconds: 3), () async {
            try {
              await APIService().fetchNextTransactions(
                  accessToken, transactionCurrentPage.value);
              setSpinning(false);
            } catch (e) {
              setSpinning(false);
              debugPrint(e.toString());
            }
          });
        } else {
          setSpinning(false);
        }
      } else {
        // print("still moving to end");
      }
    });
  }

  Widget currentScreen = const Home(
      // manager: PreferenceManager.getIstance(),
      );

  var currentPage = "Home";
  List<String> pageKeys = ["Home", "Pay", "Support", "Account"];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Pay": GlobalKey<NavigatorState>(),
    "Support": GlobalKey<NavigatorState>(),
    "Account": GlobalKey<NavigatorState>(),
  };

  var selectedIndex = 0.obs;

  void setAccessToken(String token) {
    accessToken.value = token;
  }

  void setUnreadNotifications(int num) {
    unreadNotifications.value = num;
  }

  void setSpinning(bool val) {
    isSpinning.value = val;
  }

  void setAuthenticated(bool state) {
    isAuthenticated.value = state;
  }

  void setHideNav(bool state) {
    hideNavbar.value = state;
  }

  void setHasInternet(bool state) {
    hasInternetAccess.value = state;
  }

  void setHasMoreTransactions(bool state) {
    hasMoreTransactions.value = state;
  }

  void selectTab(var currPage, String tabItem, int index) {
    if (tabItem == currentPage) {
      navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
      currentScreen = currPage;
      selectedIndex.value = index;
    } else {
      currentPage = pageKeys[index];
      selectedIndex.value = index;
      currentScreen = currPage;
    }
  }

  setUserData(var value) {
    // if (value != null) {
    userData.value = value;
    // }
  }

  void setTransactions(var list) {
    transactions.value.addAll(list);
  }

  void setAirtimeCash(var list) {
    airtimeCashData.value.addAll(list);
  }

  void setRecentTransactions(var list) {
    if (list?.length > 5) {
      recentTransactions.value = list?.sublist(0, 5);
    } else {
      recentTransactions.value = list;
    }
  }

  void setProductData(var data) {
    products.value = data;
  }

  void setLoading(bool state) {
    isLoading.value = state;
  }

  void triggerAppExit(bool state) {
    isAppClosed = state;
  }

  void resetAll() {}

  @override
  void onClose() {
    super.onClose();
    transactionsScrollController.dispose();
    messagesScrollController.dispose();
  }
}
