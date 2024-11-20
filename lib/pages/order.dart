import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopewave/services/database.dart';
import 'package:shopewave/services/shared_pref.dart';
import 'package:shopewave/widget/support_widget.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;
  getthesharedpref() async {
    email = await sharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  Stream? orderStream;

  getontheload() async {
  await getthesharedpref(); // This updates `email`.
  
  if (email != null) { // Only proceed if email is not null
    orderStream = await DatabaseMethods().getOrders(email!);
    setState(() {});
  } else {
    // Optionally handle the error or show a message to the user
    print("Error: Email is null. Unable to load orders.");
  }
}


  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, Index) {
                    DocumentSnapshot ds = snapshot.data.docs[Index];

                    return Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0, top: 10.0, bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            Image.network(
                              ds["Image"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                                width:
                                    10.0), // Adds spacing between image and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text to the start
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                SizedBox(
                                    height:
                                        5.0), // Optional spacing between text elements
                                Text(
                                  "₹" + ds["price"],
                                  style: TextStyle(
                                      color: Color(0xFFfd6f3e),
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Status" + ds["Staus"],
                                  style: TextStyle(
                                      color: Color(0xFFfd6f3e),
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        title: Text(
          "Current Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }
}
