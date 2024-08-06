import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trip/config/config.dart';
import 'package:trip/models/requests/customer_post_login_req.model.dart';
import 'package:trip/models/responses/customer_post_login_res.model.dart';
import 'package:trip/routes.dart';

class TripLoginPage extends StatefulWidget {
  const TripLoginPage({super.key});

  @override
  State<TripLoginPage> createState() => _TripLoginPageState();
}

class _TripLoginPageState extends State<TripLoginPage> {
  Text warningText = const Text('');
  TextEditingController phoneNoController = TextEditingController(text: "0812345678");
  TextEditingController passwordController = TextEditingController(text: "1234");

  var apiEndPoint;
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        apiEndPoint = config['apiEndpoint'];
        // alert
        // scaffold show apiendpoint
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(apiEndPoint)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: ListView(
        children: [
          // image
          GestureDetector(
              onDoubleTap: () => log("Double Tap Me"),
              child: Image.asset('assets/images/logo.png')),
          // input label 'phone number'
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'หมายเลขโทรศัพท์',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // input field 'phone number'
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        controller: phoneNoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'รหัสผ่าน',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // input field 'password'
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Password',
                          ),
                          obscureText: true),
                    ),
                  ])),
          // button 'register' textbutton
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: registerMethod,
                  child: const Text('สมัครสมาชิก'),
                ),
                FilledButton(
                  // onPressed: () {
                  //   log("Login");
                  //   setState(() {
                  //     text = "Login Method"; // Update the text and UI
                  //     num++;
                  //   });
                  // },
                  onPressed: loginMethod,
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [warningText],
          ),
        ],
      ),
    );
  }

  void registerMethod() {
    // route to MyAppRoutes.tripRegisterPage
    Navigator.pushNamed(context, MyAppRoutes.tripRegisterPage.value);
  }

  void loginMethod() {
    CustomerPostLoginReq data = CustomerPostLoginReq(
        phone: phoneNoController.text, password: passwordController.text);

    http
        .post(Uri.parse("$apiEndPoint/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerPostLoginReqToJson(data))
        .then((response) {
      // log(response.body);
      CustomerLoginRes customerLoginRes =
          CustomerLoginRes.fromJson(jsonDecode(response.body));
      log(customerLoginRes.message);
      log(customerLoginRes.customer.email);
      log(customerLoginRes.customer.toJson().toString());
      Navigator.pushNamed(context, MyAppRoutes.tripHomePage.value,
          arguments: customerLoginRes.customer.idx);
    }).catchError((error) {
      log(error.toString());
      // alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text(error.toString()),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
      setState(() {
        // Update the text and UI
        warningText = const Text(
          'หมายเลขโทรศัพท์หรือรหัสผ่านไม่ถูกต้อง',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        );
      });
    });

    // log(phoneNoController.text);
    // log(passwordController.text);

    // route to MyAppRoutes.tripHomePage
    // if (phoneNoController.text == "0812345678" && passwordController.text == '1234') {
    //   Navigator.pushNamed(context, MyAppRoutes.tripHomePage.value);
    // } else {
    //   setState(() {
    //     // Update the text and UI
    //     warningText = const Text(
    //       'หมายเลขโทรศัพท์หรือรหัสผ่านไม่ถูกต้อง',
    //       style: TextStyle(
    //         color: Colors.red,
    //         fontWeight: FontWeight.bold,
    //         fontSize: 16,
    //       ),
    //     );
    //   });
    // }
  }
}
