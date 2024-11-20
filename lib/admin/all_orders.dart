import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopewave/services/database.dart';
import 'package:shopewave/widget/support_widget.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderStream;

  getontheload() async {
    orderStream = await DatabaseMethods().allOrders();
    setState(() {});
  }

  @override
  void activate() {
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Name:" + ds["Name"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                SizedBox(height: 3.0),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Email:" + ds["Email"],
                                    style: AppWidget.lightTextFeildStyle(),
                                  ),
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  ds["Product"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                Text(
                                  "₹" + ds["price"],
                                  style: TextStyle(
                                      color: Color(0xFFfd6f3e),
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods().updateStatus(ds.id);
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFfd6f3e),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      "Done",
                                      style: AppWidget.semiboldTextFeildStyle(),
                                    )),
                                  ),
                                )
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
      appBar: AppBar(
        title: Text(
          "All Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}
