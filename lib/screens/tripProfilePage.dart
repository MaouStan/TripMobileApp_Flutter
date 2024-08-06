import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trip/config/config.dart';
import 'package:trip/models/requests/customer_put_update_req.mode.dart';
import 'package:trip/models/responses/customer_get_idx_res.model.dart';
import 'package:trip/models/responses/customer_get_res.model.dart';
import 'package:trip/routes.dart';

class TripProfilePage extends StatefulWidget {
  const TripProfilePage({super.key, required this.cid});
  final int cid;
  @override
  State<TripProfilePage> createState() => _TripProfilePageState();
}

class _TripProfilePageState extends State<TripProfilePage> {
  late Future<void> loadData;
  late CustomerRes customer;

  // form data textController
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = getCustomerById(widget.cid);
  }

  @override
  Widget build(BuildContext context) {
    log('Customer id: ${widget.cid}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Home Page'),
        automaticallyImplyLeading: true,
        actions: [
          // Profile Icon to show submenu
          PopupMenuButton<String>(
            onSelected: deleteUser,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
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
            nameController.text = customer.fullname;
            phoneController.text = customer.phone;
            emailController.text = customer.email;
            imageController.text = customer.image;
            return SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Image Network
                        Center(
                            child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Image.network(
                            customer.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Center(
                                    child: Text('Cannot Load Image')),
                              );
                            },
                          ),
                        )),
                        const SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'ชื่อ-นามสกุล',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'หมายเลขโทรศัพท์',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'อีเมล์',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'รูปภาพ',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: FilledButton(
                            onPressed: updateProfile,
                            child: const Text('บันทึกข้อมูล'),
                          ),
                        )
                      ])),
            );
          }),
    );
  }

  Future<void> getCustomerById(int cid) async {
    var config = await Configuration.getConfig();
    var apiEndPoint = config['apiEndpoint'];
    var url = '$apiEndPoint/customers/$cid';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    try {
      CustomerRes tempCustomer = customerResFromJson(response.body);
      customer = tempCustomer;
      log(customer.toJson().toString());
    } catch (error) {
      log("Error $error");
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  void updateProfile() {
    // confirm dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการบันทึก'),
        content: const Text('คุณแน่ใจที่จะบันทึกข้อมูล'),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยกเลิก')),
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                updateProfileService();
              },
              child: const Text('ยืนยัน'))
        ],
      ),
    );
  }

  Future<void> updateProfileService() async {
    // clear old ScaffoldMessenger
    ScaffoldMessenger.of(context).clearSnackBars();

    // check no empty
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        imageController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")));
      return;
    }

    // phone wrong format regex number 10
    if (!RegExp(r'^\d{10}$').hasMatch(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('หมายเลขโทรศัพท์ไม่ถูกต้อง')));
      return;
    }

    // email wrong format 'xxxx@xxxx.xxx' regex
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]+$')
        .hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('อีเมลไม่ถูกต้อง')));
      return;
    }

    // check changed
    if (nameController.text == customer.fullname &&
        phoneController.text == customer.phone &&
        emailController.text == customer.email &&
        imageController.text == customer.image) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("ไม่มีการเปลี่ยนแปลง")));
      return;
    }

    CustomerReq newProfile = CustomerReq(
      fullname: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      image: imageController.text,
    );

    var config = await Configuration.getConfig();
    var apiEndPoint = config['apiEndpoint'];

    try {
      // check phone or email in database already
      // get all customers GET http://192.168.237.161:3000/customers
      var response = await http.get(Uri.parse('$apiEndPoint/customers'));
      // check phone or email in database already
      List<CustomersRes> customers = customersResFromJson(response.body);
      for (CustomersRes dbCustomer in customers) {
        if (dbCustomer.phone == phoneController.text &&
                phoneController.text != customer.phone ||
            dbCustomer.email == emailController.text &&
                emailController.text != customer.email) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('ผิดพลาด'),
              content: Text(
                  'บันทึกข้อมูลไม่สำเร็จ เนื่องจากอีเมล์หรือหมายเลขโทรศัพท์มีอยู่แล้ว'),
              actions: [
                FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('ปิด'))
              ],
            ),
          );
          return;
        }
      }

      var url = '$apiEndPoint/customers/${customer.idx}';
      response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: customerReqToJson(newProfile),
      );

      var result = jsonDecode(response.body);
      log(result['message']);
      setState(() {
        customer.fullname = nameController.text;
        customer.phone = phoneController.text;
        customer.email = emailController.text;
        customer.image = imageController.text;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + error.toString()),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }

  void deleteUser(String value) {
    if (value != "delete") return;
    // alert for confirm
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจที่จะลบบัญชีผู้ใช้นี้'),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยกเลิก')),
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                deleteCustomer();
              },
              child: const Text('ยืนยัน'))
        ],
      ),
    );
  }

  Future<void> deleteCustomer() async {
    var config = await Configuration.getConfig();
    var apiEndPoint = config['apiEndpoint'];
    var url = '$apiEndPoint/customers/${customer.idx}';

    http
        .delete(
      Uri.parse(url),
    )
        .then((response) {
      try {
        var result = jsonDecode(response.body);
        log(result['message']);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('สำเร็จ'),
            content: const Text('ลบข้อมูลเรียบร้อย'),
            actions: [
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) =>
                        route.settings.name == MyAppRoutes.tripLoginPage.value);
                  },
                  child: const Text('ปิด'))
            ],
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ผิดพลาด'),
            content: Text('ลบข้อมูลไม่สำเร็จ ' + error.toString()),
            actions: [
              FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ปิด'))
            ],
          ),
        );
      }
    });
  }
}
