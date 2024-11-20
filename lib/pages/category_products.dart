import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopewave/pages/product_detail.dart';
import 'package:shopewave/services/database.dart';
import 'package:shopewave/widget/support_widget.dart';

class CategoryProducts extends StatefulWidget {
  final String category;

  const CategoryProducts({super.key, required this.category, required String categoryName});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream<QuerySnapshot>? categoryStream; // Updated to the correct type

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    categoryStream = await DatabaseMethods()
        .getProducts(widget.category); // Await for the stream
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Text(widget.category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoryStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

                return buildProductCard(data);
              },
            );
          }
          return const Center(
              child: Text("No products found in this category."));
        },
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.network(
            data["Image"],
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          Text(data["Name"] ?? "Unnamed Product",
              style: AppWidget.semiboldTextFeildStyle()), // Added null check
          buildPriceAndAddButton(data),
        ],
      ),
    );
  }

  Widget buildPriceAndAddButton(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(
          child: Text(
            data.containsKey('price')
                ? "₹${data["price"]}"
                : "Price not available",
            style: const TextStyle(
              color: Color(0xFFfd6f3e),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(
                  detail: data["Details"] ??
                      "Details not available", // Added null check
                  image: data["Image"],
                  name: data["Name"] ?? "Unnamed Product", // Added null check
                  price: data.containsKey('price')
                      ? data["price"].toString()
                      : "Price not available",
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFfd6f3e),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
