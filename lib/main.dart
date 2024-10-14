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
          } else if (provider.products == null) {
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
                                  width: 20,
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
                                  // width: 0,
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