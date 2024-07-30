import 'package:flutter/material.dart';

class WeekTwoFirstPage extends StatelessWidget {
  const WeekTwoFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        // body: Container(
        //   color: Colors.amber,
        //   width: MediaQuery.of(context).size.width,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        //         SizedBox(
        //           width: 100,
        //           height: 100,
        //           child: Container(
        //             color: Colors.blue,
        //           ),
        //         ),
        //       ]),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           // Row(
        //           //   mainAxisAlignment: MainAxisAlignment.start,
        //           //   children: [
        //           //     SizedBox(
        //           //       width: 100,
        //           //       height: 100,
        //           //       child: Container(
        //           //         color: Colors.deepPurpleAccent,
        //           //       ),
        //           //     ),
        //           //   ],
        //           // ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               SizedBox(
        //                 width: 100,
        //                 height: 100,
        //                 child: Container(
        //                   color: Colors.lightGreenAccent,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
        //                 child: SizedBox(
        //                   width: 100,
        //                   height: 100,
        //                   child: Container(
        //                     color: Colors.red,
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: 100,
        //                 height: 100,
        //                 child: Container(
        //                   color: Colors.pink,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Hello World",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    labelText: 'Enter your username',
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text('TEST')),
                      FilledButton(
                          onPressed: () {}, child: const Text("FilledButton")),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("OutlinedButton"),
                      ),
                      TextButton(
                          onPressed: () {}, child: const Text("TextButton")),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.download),
                      ),
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2-TVphB148wg1omRxgqXTMk9lDbLyunCmdw&s',
                      ),
                      Image.asset(
                          'assets/images/450259752_500439815962732_4227393547329738205_n.jpg'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
