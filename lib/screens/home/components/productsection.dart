// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:get/instance_manager.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../helper/preference/preference_manager.dart';
// import '../../../helper/state/state_manager.dart';
// import '../../product/components/productcard.dart';

// class ProductSection extends StatelessWidget {
//   final PreferenceManager manager;
//   ProductSection({
//     Key? key,
//     required this.manager,
//   }) : super(key: key);

//   final _controller = Get.find<StateController>();

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     final double itemHeight = (size.height - kToolbarHeight - 18) / 2.60;
//     final double itemWidth = size.width / 2;

//     // print("CHECKING DATA::: ${_controller.meals.value}");

//     return Obx(
//       () => Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 5.0,
//           ),
//           _controller.meals.value.isEmpty
//               ? Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 6.0,
//                       crossAxisSpacing: 6.0,
//                       childAspectRatio: (itemWidth / itemHeight),
//                     ),
//                     shrinkWrap: true,
//                     itemCount: 4,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         elevation: 1.0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: SizedBox(
//                           height: 220,
//                           width: MediaQuery.of(context).size.width * 0.4,
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               : GridView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 6.0,
//                     crossAxisSpacing: 6.0,
//                     childAspectRatio: (itemWidth / itemHeight),
//                   ),
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) => ProductCard(
//                     manager: manager,
//                     data: _controller.meals.value.elementAt(index),
//                   ),
//                   itemCount: _controller.meals.value.length,
//                 ),
//         ],
//       ),
//     );
//   }
// }
