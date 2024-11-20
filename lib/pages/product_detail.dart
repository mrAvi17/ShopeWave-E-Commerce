import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopewave/pages/payment_method_screen.dart';
import 'package:shopewave/services/database.dart';
import 'package:shopewave/services/shared_pref.dart';
import 'package:shopewave/widget/support_widget.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final String image, name, detail, price;

  const ProductDetail({
    super.key,
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image;
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
  }

  Future<void> getSharedPrefData() async {
    name = await sharedPreferenceHelper().getUserName();
    mail = await sharedPreferenceHelper().getUserEmail();
    image = await sharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfef5f1),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            Expanded(
              child: buildProductDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        Center(
          child: Image.network(
            widget.image,
            height: 400,
          ),
        ),
      ],
    );
  }

  Widget buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductNameAndPrice(),
          const SizedBox(height: 20.0),
          buildDetailsSection(),
          const SizedBox(height: 70.0),
          buildBuyNowButton(),
        ],
      ),
    );
  }

  Widget buildProductNameAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.name, style: AppWidget.boldTextFieldStyle()),
        Text(
          "₹${widget.price}",
          style: const TextStyle(
            color: Color(0xFFfd6f3e),
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Details", style: AppWidget.semiboldTextFeildStyle()),
        Text(widget.detail),
      ],
    );
  }

  Widget buildBuyNowButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PaymentMethodScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: const Color(0xFFfd6f3e),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: Text(
            "Buy Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Avinash',
        ),
      );

      displayPaymentSheet();
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((_) async {
        await DatabaseMethods().orderDetails({
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": mail,
          "Image": image,
          "ProductImage": widget.image,
          "Status": "On the way",
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const Text("Payment Successful"),
              ],
            ),
          ),
        );
        paymentIntent = null;
      });
    } on StripeException catch (e) {
      print("Error is: $e");
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled"),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer YOUR_SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('Error charging user: ${err.toString()}');
    }
    return null;
  }

  int calculateAmount(String amount) {
    return int.parse(amount) * 100;
  }
}
