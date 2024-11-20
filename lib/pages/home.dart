import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopewave/pages/category_products.dart';
import 'package:shopewave/pages/offer.dart';
import 'package:shopewave/pages/product_detail.dart';
import 'package:shopewave/pages/profile.dart';
import 'package:shopewave/services/database.dart';
import 'package:shopewave/services/shared_pref.dart';
import 'package:shopewave/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  bool search = false;
  List<String> categories = [
    "images/airpods.jpeg",
    "images/mbp16.jpeg",
    "images/g84.png",
    "images/airpods4.jpeg",
    "images/man.avif",
    "images/women.jpg",
    "images/shoes.jpg",
  ];

  List Categoryname = [
    "Watch",
    "Laptop",
    "Mobile",
    "Headphones",
    "Men's Wear",
    "Women's Wear",
    "Shoes"
  ];
  var queryResultSet = [];
  var tempSearchStore = [];
  late final DatabaseService _databaseService; // Declare the service


  inititateSearch(value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      search = true;
    });



    var capitalizedValue = value.isNotEmpty
        ? value.substring(0, 1).toUpperCase() +
            (value.length > 1 ? value.substring(1) : '')
        : '';

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(capitalizedValue).then((QuerySnapshot docs) {
        setState(() {
          queryResultSet = docs.docs.map((doc) => doc.data()).toList();
          tempSearchStore = queryResultSet.where((element) {
            return element['UpdatedName'] != null &&
                element['UpdatedName'].startsWith(capitalizedValue);
          }).toList();
        });
      });
    } else {
      setState(() {
        tempSearchStore = queryResultSet.where((element) {
          return element['UpdatedName'] != null &&
              element['UpdatedName'].startsWith(capitalizedValue);
        }).toList();
      });
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await sharedPreferenceHelper().getUserName();
    image = await sharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  

@override
void initState() {
  super.initState();
  _databaseService = DatabaseService(); 
  ontheload(); // Existing method to load user preferences
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Added scroll functionality
              child: Container(
                margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey,${name!}",
                              style: AppWidget.boldTextFieldStyle(),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Good Morning",
                              style: AppWidget.lightTextFeildStyle(),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Profile(), // Navigate to ProfilePage
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              image!,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        onChanged: (value) {
                          inititateSearch(
                              value.toUpperCase()); // Call the search function
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: AppWidget.lightTextFeildStyle(),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OfferPage(), // Navigate to OfferPage
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage("images/offer_banner.JPEG"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Explore Offers",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categories",
                                style: AppWidget.semiboldTextFeildStyle(),
                              ),
                              Text(
                                "See all",
                                style: TextStyle(
                                    color: Color(0xFFfd6f3e),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Container(
                          height: 140.0,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFD6F3E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 80,
                          child: Center(
                              child: Text(
                            "All",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: categories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CategoryTile(
                                  image: categories[index],
                                  name: Categoryname[index],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    
                    
const Text(
  "All Products",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 20),
StreamBuilder<List<Map<String, dynamic>>>(
  stream: _databaseService.getAllProducts(), // Function to fetch all products
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    final products = snapshot.data ?? [];
    if (products.isEmpty) {
      return const Center(child: Text('No products available.'));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final data = products[index];
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
                  Text(
                    data['Name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${data['price']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
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

                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    detail: data["Detail"],
                    image: data["Image"],
                    name: data["Name"],
                    price: data["price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        height: 100,
        child: Row(
          children: [
            Image.network(
              data["Image"],
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
            Text(
              data["Name"],
              style: AppWidget.semiboldTextFeildStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;

  const CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProducts(
                      category: name,
                      categoryName: '',
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: 90,
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
