import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:trip/config/config.dart';
import 'package:trip/models/requests/customer_post_register_req.model.dart';
import 'package:trip/models/responses/customer_get_res.model.dart';
import 'package:trip/routes.dart';
import 'package:http/http.dart' as http;

class TripRegisterPage extends StatefulWidget {
  const TripRegisterPage({super.key});

  @override
  State<TripRegisterPage> createState() => _TripRegisterPageState();
}

class _TripRegisterPageState extends State<TripRegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfirmController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  var apiEndPoint;
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        apiEndPoint = config['apiEndpoint'];
        log(apiEndPoint);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Register Page')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // fistname-lastname
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ชื่อ-นามสกุล"),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // phone number
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("หมายเลขโทรศัพท์"),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                // email
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("อีเมล"),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                // password
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("รหัสผ่าน"),
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                // confirm password
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ยืนยันรหัสผ่าน"),
                    TextField(
                      controller: passConfirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Image URL"),
                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                // register button
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: registerMethod,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
                // if already have account
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("มีบัญชีอยู่แล้ว?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, MyAppRoutes.tripLoginPage.value);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void registerMethod() async {
    // clear old error message
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String pass = passController.text;
    String passConfirm = passConfirmController.text;
    String image = imageController.text;

    // check
    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        passConfirm.isEmpty ||
        image.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')));
      return;
    }

    // phone wrong format regex number 10
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('หมายเลขโทรศัพท์ไม่ถูกต้อง')));
      return;
    }

    // email wrong format 'xxxx@xxxx.xxx' regex
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]').hasMatch(email)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('อีเมลไม่ถูกต้อง')));
      return;
    }

    if (pass != passConfirm) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')));
      return;
    }

    CustomerPostRegisterReq data = CustomerPostRegisterReq(
      phone: phoneController.text,
      password: passController.text,
      email: emailController.text,
      fullname: nameController.text,
      image: imageController.text,
    );

    try {
      // check phone or email in database already
      // get all customers GET http://192.168.237.161:3000/customers
      http.Response response =
          await http.get(Uri.parse("$apiEndPoint/customers"));
      // check phone or email in database already
      List<CustomersRes> customers = customersResFromJson(response.body);
      for (CustomersRes customer in customers) {
        if (customer.phone == phone || customer.email == email) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('หมายเลขโทรศัพท์หรืออีเมลนี้มีอยู่แล้ว')));
          return;
        }
      }

      // post new customer
      http.Response postResponse = await http.post(
        Uri.parse("$apiEndPoint/customers"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customerPostRegisterReqToJson(data),
      );

      log(postResponse.body);
      // route to MyAppRoutes.tripLoginPage
      Navigator.pushNamed(context, MyAppRoutes.tripLoginPage.value);
    } catch (error) {
      log(error.toString());
    }
  }
}
