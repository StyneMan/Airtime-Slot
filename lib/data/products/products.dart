class Product {
  late String id;
  late String name;
  List<Network>? networks;

  Product({
    required this.id,
    required this.name,
    required this.networks,
  });
}

class Network {
  late String name;
  late String icon;
  List<Packages>? packages;

  Network({
    required this.icon,
    required this.name,
    required this.packages,
  });
}

class Packages {
  late String name;
  late int amount;

  Packages({
    required this.amount,
    required this.name,
  });
}
