import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trip/config/config.dart';
import 'package:trip/models/responses/trip_get_res.model.dart';

class TripDetailPage extends StatefulWidget {
  const TripDetailPage({super.key, required this.idx});
  final int idx;

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late TripGetResponse trip;
  late Future<void> loadData;
  @override
  void initState() {
    super.initState();
    loadData = getTrip(widget.idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดทริป"),
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1 Title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text("ชื่อ : ${trip.name}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    // Section 2 Country
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('ประเทศ : ${trip.country}'),
                    ),
                    // Section 3 Image
                    Center(child: Image.network(trip.coverimage)),
                    // Section 4 Price
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'ราคา : ${trip.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} บาท'),
                            const SizedBox(width: 8),
                            Text('โซน : ${trip.destinationZone}'),
                          ],
                        )),
                    // Section 5 Duration
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('ระยะเวลา : ${trip.duration} วัน'),
                    ),
                    // Section 7 Description
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(trip.detail),
                    ),
                    // Section 8 Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, MyAppRoutes.tripDetailPage.value);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 46),
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('จองทริปนี้'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]);
          }),
    );
  }

  Future<void> getTrip(int idx) async {
    var config = await Configuration.getConfig();
    var apiEndPoint = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$apiEndPoint/trips/$idx'));
    if (res.statusCode == 200) {
      setState(() {
        trip = TripGetResponse.fromJson(
          jsonDecode(res.body),
        );
      });
    } else {
      log('Failed to load trip');
    }
  }
}
