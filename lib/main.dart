import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/provider.dart';

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
    return const MaterialApp(
      home: HomeScreen(),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<PostProvider>(
        builder: (BuildContext context, PostProvider value, Widget? child) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.products != null
              ? ListView.builder(
            itemCount: provider.products!.data!.orderList!.length,
            itemBuilder: (context, index) {
              var order = provider.products!.data!.orderList![index];

              // i print this to see API response
              print('KOT Start Time: ${order.kotStartTime}');

              var kotStartTime = order.kotStartTime;
              var formattedTime = 'Invalid Time';

              if (kotStartTime != null && kotStartTime.isNotEmpty) {
                try {
                  var parsedTime =
                  DateFormat('dd/MM/yyyy HH:mm:ss').parse(kotStartTime);
                  formattedTime = DateFormat('hh:mm a').format(parsedTime);
                } catch (e) {
                  print('Error parsing KOT start time: $e');
                }
              }

              return Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20),
                              child: Text(
                                '#${order.orderId.toString()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 20),
                              child: Text(
                                order.tableNo != null && order.tableNo!.isNotEmpty
                                    ? 'Table: ${order.tableNo.toString()}'
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            'KOT - ${order.kotId.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 20,
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
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
                            horizontal: BorderSide(color: Colors.black38))),
                    height: 50,
                    child: ListTile(
                      leading: const Text(
                        'Qty',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Items',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: Text(
                        formattedTime,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.sectionData!.length,
                        itemBuilder: (context, sectionIndex) {
                          var section = order.sectionData![sectionIndex];

                          return Card(
                            elevation: 6,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.brown,
                                  height: MediaQuery.of(context).size.width * .065,
                                  width: MediaQuery.of(context).size.width * .27,
                                  child: Center(
                                    child: Text(
                                      section.itemList!.isNotEmpty
                                          ? (section.sectionName ??
                                          'No Category')
                                          .toUpperCase()
                                          : 'No Category',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: section.itemList!.length,
                                  itemBuilder: (context, itemIndex) {
                                    if (itemIndex < section.itemList!.length) {
                                      var item = section.itemList![itemIndex];

                                      var customizationDetails =
                                          item.customizationDetails ?? '';

                                      var choiceDetails =
                                          item.choiceDetails ?? '';

                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: Text(
                                              item.quantity.toString(),
                                              style: const TextStyle(
                                                  fontSize: 15),
                                            ),
                                            title:
                                            Text(item.itemName.toString()),
                                            trailing: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.all(
                                                  Radius.circular(3),
                                                ),
                                              ),
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  .03,
                                              width: 75,
                                              child: Center(
                                                child: Text(
                                                  item.itemStatus.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Show ChoiceDetails
                                          choiceDetails.isNotEmpty
                                              ? Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 32),
                                                  child: Text(
                                                    choiceDetails,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors
                                                          .black87,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              : const SizedBox.shrink(),
                                          // Show CustomizationDetails
                                          customizationDetails.isNotEmpty
                                              ? Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 2),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 25),
                                                  child: Text(
                                                    customizationDetails,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors
                                                          .black87,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              : const SizedBox.shrink(),
                                          const Divider(height: 1),
                                        ],
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Container to show KotStatus
                      Container(
                        color: Colors.grey,
                        height:
                        MediaQuery.of(context).size.height * .045,
                        width: MediaQuery.of(context).size.height * .2,
                        child: Center(
                          child: Text(
                            provider.products!.data!.orderList![index]
                                .kotStatus
                                .toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ],
              );
            },
          )
              : const Center(child: Text('No products found')); // Added null case
        },
      ),
    );
  }
}