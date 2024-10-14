import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/provider.dart';

import 'package:flutter/gestures.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.invertedStylus,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          }),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Interview Task'.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<PostProvider>(
        builder: (BuildContext context, PostProvider value, Widget? child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.products == null ||
                      provider.products!.data == null ||
                      provider.products!.data!.orderList == null ||
                      provider.products!.data!.orderList!.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.8,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.products!.data!.orderList!.length,
              itemBuilder: (context, index) {
                var order = provider.products!.data!.orderList![index];

                if (order == null) {
                  return const SizedBox();
                }

                var kotStartTime = order.kotStartTime;
                var formattedTime = 'Invalid Time';

                if (kotStartTime != null && kotStartTime.isNotEmpty) {
                  try {
                    var parsedTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(kotStartTime);
                    formattedTime = DateFormat('hh:mm a').format(parsedTime);
                  } catch (e) {
                    print('Error parsing KOT start time: $e');
                  }
                }

                return Container(
                  width: 400,
                  margin: const EdgeInsets.only(right: 10),
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    // This block of code is for show Order ID
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '#${order.orderId}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),

                                    // This block of code is for show Order Type or TableNo.
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        order.tableNo != null && order.tableNo!.isNotEmpty
                                            ? 'Table: ${order.tableNo}'
                                            : order.orderType.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.white,
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),

                                // This block of code is for show KOT ID
                                Text(
                                  'KOT - ${order.kotId}',
                                  style: const TextStyle(color: Colors.white),
                                ),

                                const VerticalDivider(
                                  color: Colors.white,
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),

                                // This block of code is for show UserName
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Text(
                                    order.posUserName ?? 'No User',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black38),
                              ),
                            ),
                            height: 50,
                            child: ListTile(
                              leading: const Text(
                                'Qty',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Items',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ),
                              trailing: Text(
                                formattedTime,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: order.sectionData!.map((section) {
                                return Container(
                                  margin: EdgeInsets.zero,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          color: Colors.brown,
                                          height: 35,
                                          width: 128,
                                          padding: const EdgeInsets.all(4.0),
                                          child: Center(
                                            child: Text(
                                              section.sectionName!.isNotEmpty
                                                  ? (section.sectionName ?? 'No Category').toUpperCase()
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: section.itemList!.length,
                                        itemBuilder: (context, itemIndex) {
                                          var item = section.itemList![itemIndex];

                                          var customizationDetails = item.customizationDetails ?? '';

                                          var choiceDetails = item.choiceDetails ?? '';

                                          // This block of code is for show ItemList data
                                          return Column(
                                            children: [
                                              ListTile(
                                                leading: Text(
                                                  item.quantity.toString(),
                                                  style: const TextStyle(fontSize: 15),
                                                ),
                                                title: Text(item.itemName ?? ''),
                                                trailing: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                                  ),
                                                  height: 25,
                                                  width: 75,
                                                  child: Center(
                                                    child: Text(
                                                      item.itemStatus ?? 'Pending',
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // This block of code is for Customization Details
                                              if (customizationDetails.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.circle, size: 10, color: Colors.black54),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          customizationDetails,
                                                          style: const TextStyle(fontSize: 13),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              // This block of code is for Choice Details
                                              if (choiceDetails.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.circle, size: 10, color: Colors.black54),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          choiceDetails,
                                                          style: const TextStyle(fontSize: 13),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // This block of code is for KOT Status
                          Center(
                            child: Container(
                              height: 35,
                              width: 160,
                              color: Colors.grey.shade400,
                              child: Center(
                                child: Text(
                                  order.kotStatus.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}




// This Is First Version, Show Data In Single Vertical Scroll Direction

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:task/provider/provider.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PostProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<PostProvider>(context, listen: false).fetchProducts();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<PostProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Interview Task'.toUpperCase(),
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Consumer<PostProvider>(
//         builder: (BuildContext context, PostProvider value, Widget? child) {
//           return provider.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : provider.products != null
//               ? ListView.builder(
//             itemCount: provider.products!.data!.orderList!.length,
//             itemBuilder: (context, index) {
//               var order = provider.products!.data!.orderList![index];
//
//               // i print this to see API response
//               print('KOT Start Time: ${order.kotStartTime}');
//
//               var kotStartTime = order.kotStartTime;
//               var formattedTime = 'Invalid Time';
//
//               if (kotStartTime != null && kotStartTime.isNotEmpty) {
//                 try {
//                   var parsedTime =
//                   DateFormat('dd/MM/yyyy HH:mm:ss').parse(kotStartTime);
//                   formattedTime = DateFormat('hh:mm a').format(parsedTime);
//                 } catch (e) {
//                   print('Error parsing KOT start time: $e');
//                 }
//               }
//
//               return Column(
//                 children: [
//                   Container(
//                     height: 50,
//                     color: Colors.red,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 5, left: 20),
//                               child: Text(
//                                 '#${order.orderId.toString()}',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   bottom: 5, left: 20),
//                               child: Text(
//                                 order.tableNo != null && order.tableNo!.isNotEmpty
//                                     ? 'Table: ${order.tableNo.toString()}'
//                                     : order.orderType.toString(),
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const VerticalDivider(
//                           color: Colors.white,
//                           width: 20,
//                           thickness: 2,
//                           indent: 10,
//                           endIndent: 10,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 10),
//                           child: Text(
//                             'KOT - ${order.kotId.toString()}',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         const VerticalDivider(
//                           color: Colors.white,
//                           width: 20,
//                           thickness: 2,
//                           indent: 10,
//                           endIndent: 10,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 20),
//                           child: Text(
//                             order.posUserName ?? 'No User',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: const BoxDecoration(
//                         color: Colors.white,
//                         border: Border.symmetric(
//                             horizontal: BorderSide(color: Colors.black38))),
//                     height: 50,
//                     child: ListTile(
//                       leading: const Text(
//                         'Qty',
//                         style: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                       title: const Padding(
//                         padding: EdgeInsets.only(left: 20),
//                         child: Text(
//                           'Items',
//                           style: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       trailing: Text(
//                         formattedTime,
//                         style: const TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: order.sectionData!.length,
//                         itemBuilder: (context, sectionIndex) {
//                           var section = order.sectionData![sectionIndex];
//
//                           return Card(
//                             elevation: 6,
//                             color: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(0),
//                             ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   color: Colors.brown,
//                                   height: MediaQuery.of(context).size.width * .065,
//                                   width: MediaQuery.of(context).size.width * .27,
//                                   child: Center(
//                                     child: Text(
//                                       section.itemList!.isNotEmpty
//                                           ? (section.sectionName ??
//                                           'No Category')
//                                           .toUpperCase()
//                                           : 'No Category',
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           letterSpacing: 1),
//                                     ),
//                                   ),
//                                 ),
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: section.itemList!.length,
//                                   itemBuilder: (context, itemIndex) {
//                                     if (itemIndex < section.itemList!.length) {
//                                       var item = section.itemList![itemIndex];
//
//                                       var customizationDetails =
//                                           item.customizationDetails ?? '';
//
//                                       var choiceDetails =
//                                           item.choiceDetails ?? '';
//
//                                       return Column(
//                                         children: [
//                                           ListTile(
//                                             leading: Text(
//                                               item.quantity.toString(),
//                                               style: const TextStyle(
//                                                   fontSize: 15),
//                                             ),
//                                             title:
//                                             Text(item.itemName.toString()),
//                                             trailing: Container(
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.red,
//                                                 borderRadius:
//                                                 BorderRadius.all(
//                                                   Radius.circular(3),
//                                                 ),
//                                               ),
//                                               height:
//                                               MediaQuery.of(context)
//                                                   .size
//                                                   .height *
//                                                   .03,
//                                               width: 75,
//                                               child: Center(
//                                                 child: Text(
//                                                   item.itemStatus.toString(),
//                                                   style: const TextStyle(
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           // Show ChoiceDetails
//                                           choiceDetails.isNotEmpty
//                                               ? Padding(
//                                             padding:
//                                             const EdgeInsets.symmetric(
//                                                 horizontal: 16,
//                                                 vertical: 8),
//                                             child: Row(
//                                               children: [
//                                                 const Padding(
//                                                   padding:
//                                                   EdgeInsets.only(
//                                                       left: 0),
//                                                   child: Icon(
//                                                     Icons.circle,
//                                                     size: 10,
//                                                     color: Colors.black54,
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .only(
//                                                       left: 32),
//                                                   child: Text(
//                                                     choiceDetails,
//                                                     style: const TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors
//                                                           .black87,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                               : const SizedBox.shrink(),
//                                           // Show CustomizationDetails
//                                           customizationDetails.isNotEmpty
//                                               ? Padding(
//                                             padding:
//                                             const EdgeInsets.symmetric(
//                                                 horizontal: 16,
//                                                 vertical: 8),
//                                             child: Row(
//                                               children: [
//                                                 const Padding(
//                                                   padding:
//                                                   EdgeInsets.only(
//                                                       left: 2),
//                                                   child: Icon(
//                                                     Icons.circle,
//                                                     size: 10,
//                                                     color: Colors.black54,
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .only(
//                                                       left: 25),
//                                                   child: Text(
//                                                     customizationDetails,
//                                                     style: const TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors
//                                                           .black87,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                               : const SizedBox.shrink(),
//                                           const Divider(height: 1),
//                                         ],
//                                       );
//                                     } else {
//                                       return const SizedBox.shrink();
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       // Container to show KotStatus
//                       Container(
//                         color: Colors.grey,
//                         height:
//                         MediaQuery.of(context).size.height * .045,
//                         width: MediaQuery.of(context).size.height * .2,
//                         child: Center(
//                           child: Text(
//                             provider.products!.data!.orderList![index]
//                                 .kotStatus
//                                 .toString(),
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 60,
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           )
//               : const Center(child: Text('No products found')); // Added null case
//         },
//       ),
//     );
//   }
// }





// This is Second Version, Show data in GridView and Scroll Horizontally

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:task/provider/provider.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PostProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<PostProvider>(context, listen: false).fetchProducts();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<PostProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Interview Task'.toUpperCase(),
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Consumer<PostProvider>(
//         builder: (BuildContext context, PostProvider value, Widget? child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (provider.products == null) {
//             return const Center(child: Text('No products found'));
//           } else {
//             return GridView.builder(
//               padding: const EdgeInsets.all(10),
//               scrollDirection: Axis.horizontal,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 1,
//                   childAspectRatio: 1.8,
//                   mainAxisSpacing: 10
//               ),
//               itemCount: provider.products!.data!.orderList!.length,
//               itemBuilder: (context, index) {
//                 var order = provider.products!.data!.orderList![index];
//
//                 var kotStartTime = order.kotStartTime;
//                 var formattedTime = 'Invalid Time';
//
//                 if (kotStartTime != null && kotStartTime.isNotEmpty) {
//                   try {
//                     var parsedTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(kotStartTime);
//                     formattedTime = DateFormat('hh:mm a').format(parsedTime);
//                   } catch (e) {
//                     print('Error parsing KOT start time: $e');
//                   }
//                 }
//
//                 return Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(15),
//                             topRight: Radius.circular(15),
//                           ),
//                         ),
//                         height: 50,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//
//                                 // This block of code is for show Order ID
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 5, left: 30),
//                                   child: Text(
//                                     '#${order.orderId}',
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//
//                                 // This block of code is for show Order Type or TableNo.
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 5, left: 20),
//                                   child: Text(
//                                     order.tableNo != null && order.tableNo!.isNotEmpty
//                                         ? 'Table: ${order.tableNo}'
//                                         : order.orderType.toString(),
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const VerticalDivider(
//                               color: Colors.white,
//                               width: 20,
//                               thickness: 2,
//                               indent: 10,
//                               endIndent: 10,
//                             ),
//
//                             // This block of code is for show KOT ID
//                             Text(
//                               'KOT - ${order.kotId}',
//                               style: const TextStyle(color: Colors.white),
//                             ),
//
//                             const VerticalDivider(
//                               color: Colors.white,
//                               width: 20,
//                               thickness: 2,
//                               indent: 10,
//                               endIndent: 10,
//                             ),
//
//                             // This block of code is for show UserName
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                               child: Text(
//                                 order.posUserName ?? 'No User',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           border: Border.symmetric(
//                             horizontal: BorderSide(color: Colors.black38),
//                           ),
//                         ),
//                         height: 50,
//                         child: ListTile(
//                           leading: const Text(
//                             'Qty',
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                           title: const Padding(
//                             padding: EdgeInsets.only(left: 20),
//                             child: Text(
//                               'Items',
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           trailing: Text(
//                             formattedTime,
//                             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: order.sectionData!.map((section) {
//                             return Container(
//                               margin: EdgeInsets.zero,
//                               color: Colors.white,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Center(
//                                     child: Container(
//                                       color: Colors.brown,
//                                       height: MediaQuery.of(context).size.width * .018,
//                                       width: MediaQuery.of(context).size.width * .08,
//                                       padding: const EdgeInsets.all(4.0),
//                                       child: Center(
//                                         child: Text(section.itemList!.isNotEmpty ?
//                                         (section.sectionName ?? 'No Category').toUpperCase() : 'No Category',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             letterSpacing: 1.2,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   ListView.builder(
//                                     shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: section.itemList!.length,
//                                     itemBuilder: (context, itemIndex) {
//                                       var item = section.itemList![itemIndex];
//
//                                       var customizationDetails = item.customizationDetails ?? '';
//
//                                       var choiceDetails = item.choiceDetails ?? '';
//
//                                       // This block of code is for show ItemList data
//                                       return Column(
//                                         children: [
//                                           ListTile(
//                                             leading: Text(
//                                               item.quantity.toString(),
//                                               style: const TextStyle(fontSize: 15),
//                                             ),
//                                             title: Text(item.itemName ?? ''),
//                                             trailing: Container(
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.red,
//                                                 borderRadius: BorderRadius.all(Radius.circular(3)),
//                                               ),
//                                               height: 25,
//                                               width: 75,
//                                               child: Center(
//                                                 child: Text(
//                                                   item.itemStatus ?? 'Pending',
//                                                   style: const TextStyle(color: Colors.white),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//
//                                           // This block of code is for Customization Details
//                                           if (customizationDetails.isNotEmpty)
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                                               child: Row(
//                                                 children: [
//                                                   const Icon(Icons.circle, size: 10, color: Colors.black54),
//                                                   const SizedBox(width: 8),
//                                                   Expanded(
//                                                     child: Text(
//                                                       customizationDetails,
//                                                       style: const TextStyle(fontSize: 13),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//
//                                           // This block of code is for Choice Details
//                                           if (choiceDetails.isNotEmpty)
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                                               child: Row(
//                                                 children: [
//                                                   const Icon(Icons.circle, size: 10, color: Colors.black54),
//                                                   const SizedBox(width: 8),
//                                                   Expanded(
//                                                     child: Text(
//                                                       choiceDetails,
//                                                       style: const TextStyle(fontSize: 13),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // This block of code is for KOT Status
//                       Center(
//                         child: Container(
//                           height: MediaQuery.of(context).size.height * .045,
//                           width: MediaQuery.of(context).size.width * .08,
//                           color: Colors.grey.shade400,
//                           child: Center(
//                             child: Text(
//                               order.kotStatus.toString(),
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }