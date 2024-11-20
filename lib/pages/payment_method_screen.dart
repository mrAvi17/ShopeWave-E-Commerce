import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int type = 1;

  void handleRadio(Object? e) => setState(() {
        type = e as int;
      });
  Future<void> initiateUPIPayment() async {
    String upiId = Uri.encodeComponent("mishraavinash53073@oksbi"); // UPI ID
    String payeeName = Uri.encodeComponent("ShopWave"); // Payee name
    String amount = Uri.encodeComponent("2"); // Payment amount
    String currency = Uri.encodeComponent("INR"); // Currency

    // Minimal UPI URL without transaction ID
    final Uri upiUrl = Uri.parse("upi://pay?pa=mishraavinash53073@oksbi&pn=ShopWave&am=2");


    if (await canLaunchUrl(upiUrl)) {
      await launchUrl(upiUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'No UPI app found. Please install a UPI app to continue.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Method"),
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                // GPay Payment Option
                Container(
                  width: size.width,
                  height: 55,
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    border: type == 1
                        ? Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 235, 75, 75),
                          )
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Radio(
                            value: 1,
                            groupValue: type,
                            onChanged: handleRadio,
                            activeColor: const Color.fromARGB(255, 235, 75, 75),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 190),
                            child: Text(
                              "GPay",
                              style: type == 1
                                  ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                  : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          Image.asset(
                            "images/GPay.png",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // RuPay Payment Option
                Container(
                  width: size.width,
                  height: 55,
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    border: type == 2
                        ? Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 235, 75, 75),
                          )
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Radio(
                            value: 2,
                            groupValue: type,
                            onChanged: handleRadio,
                            activeColor: const Color.fromARGB(255, 235, 75, 75),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 190),
                            child: Text(
                              "RuPay",
                              style: type == 2
                                  ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                  : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          Image.asset(
                            "images/Rupay.png",
                            width: 67,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100),
                // Subtotal, Shipping Fee, and Total Payment Sections
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub-Total",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹1",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shipping Fee",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹1",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Divider(
                  height: 30,
                  color: Colors.black,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Payment",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹2",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent),
                    )
                  ],
                ),
                SizedBox(height: 20),
                // Confirm Payment Button
                ElevatedButton(
                  onPressed: initiateUPIPayment, // Call the payment method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Button color
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'Confirm Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
