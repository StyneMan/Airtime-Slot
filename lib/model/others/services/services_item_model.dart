import 'package:flutter/material.dart';

class ServiceItemModel {
  late String name;
  late Color color;
  late IconData icon;

  ServiceItemModel({
    required this.name,
    required this.icon,
    required this.color,
  });
}

List<ServiceItemModel> serviceList = [
  ServiceItemModel(
    name: "Data",
    color: Colors.blueGrey,
    icon: Icons.wifi,
  ),
  ServiceItemModel(
    name: "Electricity",
    color: Colors.deepOrange,
    icon: Icons.lightbulb_outline,
  ),
  ServiceItemModel(
    name: "Airtime",
    color: Colors.yellow,
    icon: Icons.sim_card,
  ),
  ServiceItemModel(
    name: "Cable TV",
    color: Colors.green,
    icon: Icons.tv,
  ),
  ServiceItemModel(
    name: "Airtime Swap",
    color: Colors.deepOrange,
    icon: Icons.swap_horizontal_circle_rounded,
  ),
  // ServiceItemModel(
  //   name: "Education",
  //   color: Colors.deepPurple,
  //   icon: Icons.school_rounded,
  // ),
  // ServiceItemModel(
  //   name: "Others",
  //   color: Colors.brown,
  //   icon: Icons.more_horiz_rounded,
  // ),
];
