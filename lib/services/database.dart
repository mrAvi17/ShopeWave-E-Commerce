import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserDetails(
      Map<String, dynamic> userInfoMap, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<void> addAllProducts(
      Map<String, dynamic> userInfoMap, String userId) async {
    await FirebaseFirestore.instance.collection("Products").add(userInfoMap);
  }

  Future<void> addProduct(
      Map<String, dynamic> userInfoMap, String categoryname) async {
    await FirebaseFirestore.instance.collection(categoryname).add(userInfoMap);
  }

  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .update({"Status": "Deliverd"});
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<Stream<QuerySnapshot>> allOrders() async {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("staus", isEqualTo: "On the way")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return FirebaseFirestore.instance
        .collection("Orders")
        .where("Email", isEqualTo: email)
        .snapshots();
  }

  Future orderDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Oredrs")
        .add(userInfoMap);
  }

  Future<QuerySnapshot> search(String updatedname) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .where("SearchKey",
            isEqualTo: updatedname.substring(0, 1).toUpperCase())
        .get();
  }


  
}

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch offer products
  Stream<List<Map<String, dynamic>>> getOfferProducts() {
    return _firestore
        .collection('Products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
  Stream<List<Map<String, dynamic>>> getAllProducts() {
  return FirebaseFirestore.instance.collection('Products').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
      );
}
Future<void> addOrderToFirestore(String email, Map<String, dynamic> orderDetails) async {
  try {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(email) // Group orders by user email
        .collection('userOrders') // Sub-collection for user-specific orders
        .add(orderDetails);

    print("Order added successfully.");
  } catch (e) {
    print("Error adding order: $e");
  }
}
void onPaymentSuccess(String email, String productName, String imageUrl, String price) async {
  // Define the order details
  Map<String, dynamic> orderDetails = {
    "Name": productName,
    "Image": imageUrl,
    "price": price,
    "Status": "Ordered", // Initial status (can later be updated as 'Shipped' or 'Delivered')
    "timestamp": FieldValue.serverTimestamp(),
  };

  // Call method to add the order to Firestore
  await addOrderToFirestore(email, orderDetails);
}


}
