import 'package:flutter/material.dart';
import 'package:shopewave/services/database.dart';
import 'package:shopewave/pages/product_detail.dart';

class OfferPage extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _databaseService.getOfferProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final offerProducts = snapshot.data ?? [];
          if (offerProducts.isEmpty) {
            return const Center(child: Text('No offers available.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two products per row
              childAspectRatio: 0.75, // Adjust for better layout
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: offerProducts.length,
            itemBuilder: (context, index) {
              final data = offerProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        detail: data["Detail"],
                        image: data["Image"],
                        name: data["Name"],
                        price: data["price"],
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              data['Image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Product Name
                        Text(
                          data['Name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        // Product Price
                        Text(
                          '₹${data['price']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Add Button
                        ElevatedButton(
                          onPressed: () {
                            // Action to add product to cart
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(5),
                            backgroundColor: Colors.orange,
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
