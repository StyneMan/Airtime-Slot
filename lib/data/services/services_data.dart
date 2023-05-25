class ServicesData {
  late String title;
  late String icon;

  ServicesData({
    required this.icon,
    required this.title,
  });
}

List<ServicesData> rechargeList = [
  ServicesData(
    icon: "assets/images/simcard.png",
    title: "Airtime",
  ),
  ServicesData(
    icon: "assets/images/wifi.png",
    title: "Data",
  ),
  ServicesData(
    icon: "assets/images/cable_tv.png",
    title: "Cable TV",
  ),
  ServicesData(
    icon: "assets/images/power_plug.png",
    title: "Electricity",
  ),
];

List<ServicesData> othersList = [
  ServicesData(
    icon: "assets/images/airtime_cash.png",
    title: "Airtime Swap",
  ),
  ServicesData(
    icon: "assets/images/wallet.png",
    title: "Fund Wallet",
  ),
  ServicesData(
    icon: "assets/images/insurance.png",
    title: "Withdraw",
  ),
];
