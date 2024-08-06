import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trip/config/config.dart';
import 'package:trip/models/responses/destinations_get_res.mode.dart';
import 'package:trip/models/responses/trip_get_res.model.dart';
import 'package:http/http.dart' as http;
import 'package:trip/routes.dart';

class TripHomePage extends StatefulWidget {
  const TripHomePage({super.key, required this.cid});
  final int cid;
  @override
  State<TripHomePage> createState() => _TripHomePageState();
}

class _TripHomePageState extends State<TripHomePage> {
  List<TripGetResponse> listOfTrips = [];
  List<DestinationsGetResponse> listOfDestination = [];

  late Future<void> loadData;
  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Home Page'),
        automaticallyImplyLeading: false,
        actions: [
          // Profile Icon to show submenu
          PopupMenuButton<String>(
            onSelected: menuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1
                  const Text("ปลายทาง"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // buttons
                        ...listOfDestination.map((destination) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: FilledButton(
                                onPressed: () {
                                  getTrips(
                                      destinationId:
                                          destination.zone.toString());
                                },
                                child: Text(destination.zone))))
                      ],
                    ),
                  ),
                  // Section 2 List of Trips
                  Expanded(
                    child: ListView.builder(
                      itemCount: listOfTrips.length,
                      itemBuilder: (context, index) {
                        final trip = listOfTrips[index];
                        return Card(
                          color: index % 2 == 0
                              ? Colors.red[100]
                              : Colors.orange[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // title
                                Text(
                                  '${trip.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // image
                                    SizedBox(
                                      width: 180,
                                      height: 110,
                                      child: Image.network(
                                        trip.coverimage as String,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: const Center(
                                                child:
                                                    Text('Cannot Load Image')),
                                          );
                                        },
                                      ),
                                    ),
                                    // description
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('ประเทศ${trip.country}'),
                                            Text(
                                                'ระยะเวลา ${trip.duration} วัน'),
                                            Text(
                                                'ราคา ${trip.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} บาท'),
                                            // button
                                            FilledButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      '/trip_detail_page/${trip.idx}');
                                                },
                                                child: const Text(
                                                    'ดูรายละเอียดเพิ่มเติม')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Future<void> getTrips({String destinationId = "ทั้งหมด"}) async {
    var config = await Configuration.getConfig();
    var apiEndPoint = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$apiEndPoint/destinations'));
    if (res.statusCode == 200) {
      var data = destinationsGetResponseFromJson(res.body);
      setState(() {
        listOfDestination = data;
        // add "ทั้งหมด"
        listOfDestination.insert(
            0, DestinationsGetResponse(idx: 0, zone: 'ทั้งหมด'));
      });
    }

    res = await http.get(Uri.parse('$apiEndPoint/trips'));
    if (res.statusCode == 200) {
      var data = tripGetResponseFromJson(res.body);
      setState(() {
        listOfTrips = data;
        if (destinationId != "ทั้งหมด") {
          listOfTrips = listOfTrips
              .where((trip) => trip.destinationZone == destinationId.toString())
              .toList();
        }
      });
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  void menuSelected(String value) {
    log("Actions : " + value);
    if (value == 'logout') {
      Navigator.of(context).popUntil(
          (route) => route.settings.name == MyAppRoutes.tripLoginPage.value);
    } else {
      Navigator.pushNamed(context, MyAppRoutes.tripProfilePage.value,
          arguments: widget.cid);
    }
  }
}
