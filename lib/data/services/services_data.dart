import '../products/products.dart';

class ServicesData {
  late String title;
  late String icon;
  Product? product;

  ServicesData({
    required this.icon,
    required this.title,
    this.product,
  });
}

List<ServicesData> rechargeList = [
  ServicesData(
    icon: "assets/images/simcard.png",
    title: "Airtime",
    product: Product(
      id: "1",
      name: "airtime",
      networks: [
        Network(
          icon: "assets/images/airtel.png",
          name: "Airtel",
          packages: [],
        ),
        Network(
          icon: "assets/images/mtn.jpg",
          name: "MTN",
          packages: [],
        ),
        Network(
          icon: "assets/images/9mobile.png",
          name: "9Mobile",
          packages: [],
        ),
        Network(
          icon: "assets/images/glo.png",
          name: "Glo",
          packages: [],
        ),
      ],
    ),
  ),
  ServicesData(
    icon: "assets/images/wifi.png",
    title: "Data",
    product: Product(
      id: "1",
      name: "Data",
      networks: [
        Network(
          icon: "assets/images/airtel.png",
          name: "Airtel",
          packages: [
            Packages(amount: 500, name: "Airtel 500 1GB"),
            Packages(amount: 1000, name: "Airtel 1000 2GB"),
            Packages(amount: 1600, name: "Airtel 1600 3GB"),
          ],
        ),
        Network(
          icon: "assets/images/mtn.jpg",
          name: "MTN",
          packages: [
            Packages(amount: 300, name: "MTN 300 1GB  Daily"),
            Packages(amount: 500, name: "MTN 500 1GB"),
            Packages(amount: 1000, name: "MTN 1000 1.5GB 2 Weeks"),
            Packages(amount: 1500, name: "MTN 1500 2.5GB"),
            Packages(amount: 5000, name: "MTN 5000 16GB"),
          ],
        ),
        Network(
          icon: "assets/images/9mobile.png",
          name: "9Mobile",
          packages: [
            Packages(amount: 400, name: "9Mobile 400 500MB"),
            Packages(amount: 700, name: "9Mobile 700 1GB"),
            Packages(amount: 1200, name: "9Mobile 1200 2GB"),
            Packages(amount: 5000, name: "9Mobile 5000 10GB"),
          ],
        ),
        Network(
          icon: "assets/images/glo.png",
          name: "Glo",
          packages: [
            Packages(amount: 500, name: "Glo 500 1GB"),
            Packages(amount: 1000, name: "Glo 1000 2.5GB"),
          ],
        ),
      ],
    ),
  ),
  ServicesData(
    icon: "assets/images/cable_tv.png",
    title: "Cable TV",
    product: Product(
      id: "1",
      name: "cable tv",
      networks: [
        Network(
          icon: "assets/images/dstv.png",
          name: "DSTV",
          packages: [
            Packages(amount: 500, name: "DSTV joli at N500"),
            Packages(amount: 1000, name: "DSTV max at N100"),
            Packages(amount: 1600, name: "DSTV super at N160"),
          ],
        ),
        Network(
          icon: "assets/images/gotv.png",
          name: "GOTV",
          packages: [
            Packages(amount: 1000, name: "GOTV Jinja at N1000"),
            Packages(amount: 2500, name: "GOTV Joli at N2500"),
            Packages(amount: 5000, name: "GOTV Max at N5000"),
          ],
        ),
        Network(
          icon: "assets/images/startimes.png",
          name: "Startimes",
          packages: [
            Packages(amount: 2500, name: "Startimes Mini at N2500"),
            Packages(amount: 7000, name: "Startimes Super at N7000"),
          ],
        ),
      ],
    ),
  ),
  ServicesData(
    icon: "assets/images/power_plug.png",
    title: "Electricity",
    product: Product(
      id: "1",
      name: "electricity",
      networks: [
        Network(
          icon: "assets/images/phed.png",
          name: "PHEDC",
          packages: [],
        ),
        Network(
          icon: "assets/images/aedc_icon.jpeg",
          name: "AEDC",
          packages: [],
        ),
        Network(
          icon: "assets/images/ekedc_icon.jpeg",
          name: "EKEDC",
          packages: [],
        ),
        Network(
          icon: "assets/images/ikedc_icon.png",
          name: "IKEDC",
          packages: [],
        ),
        Network(
          icon: "assets/images/jedc_icon.png",
          name: "JEDC",
          packages: [],
        ),
        Network(
          icon: "assets/images/kedco_icon.png",
          name: "KEDCO",
          packages: [],
        ),
      ],
    ),
  ),
];

List<ServicesData> othersList = [
  ServicesData(
    icon: "assets/images/airtime_cash.png",
    title: "Airtime to cash",
  ),
  ServicesData(
    icon: "assets/images/insurance.png",
    title: "Insurance",
  ),
  ServicesData(
    icon: "assets/images/wallet.png",
    title: "Fund Wallet",
  ),
  ServicesData(
    icon: "assets/images/telephone.png",
    title: "Landline",
  ),
];
