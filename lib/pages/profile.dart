import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopewave/admin/add_product.dart';
import 'package:shopewave/pages/address.dart';
import 'package:shopewave/pages/onbording.dart';
import 'package:shopewave/services/auth.dart';
import 'package:shopewave/services/shared_pref.dart';
import 'package:shopewave/widget/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  String? streetAddress, city, postalCode;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  gethesharedpref() async {
    image = await sharedPreferenceHelper().getUserImage();
    name = await sharedPreferenceHelper().getUserName();
    email = await sharedPreferenceHelper().getUserEmail();
    streetAddress =
        await sharedPreferenceHelper().getUserStreetAddress();
    city = await sharedPreferenceHelper().getUserCity();
    postalCode =
        await sharedPreferenceHelper().getUserPostalCode();
    setState(() {});
  }

  Future<void> uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("productImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await sharedPreferenceHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    gethesharedpref();
  }

  Future<void> getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      await uploadItem();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        title: Text(
          "Profile",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                image ?? '',
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildProfileInfo("Name", name ?? '', Icons.person_outline),
                  SizedBox(height: 20),
                  buildProfileInfo("Email", email ?? '', Icons.mail_outline),
                  SizedBox(height: 20),
                  buildProfileActionButton("Log Out", Icons.logout, () async {
                    await AuthMethods().SignOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Onboarding()));
                    });
                  }),
                  SizedBox(height: 20),
                  buildProfileActionButton(
                      "Delete Account", Icons.delete_outline, () async {
                    await AuthMethods().deleteuser().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProduct()));
                    });
                  }),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Address",
                              style: AppWidget.boldTextFieldStyle(),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              streetAddress ?? "Add your street address",
                              style: AppWidget.semiboldTextFeildStyle(),
                            ),
                            Text(
                              city ?? "Add your city",
                              style: AppWidget.semiboldTextFeildStyle(),
                            ),
                            Text(
                              postalCode ?? "Add your postal code",
                              style: AppWidget.semiboldTextFeildStyle(),
                            ),
                            TextButton(
                              onPressed: () async {
                                final updatedAddress = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddressEditScreen(
                                      currentAddress: streetAddress,
                                      currentCity: city,
                                      currentPostalCode: postalCode,
                                    ),
                                  ),
                                );

                                if (updatedAddress != null) {
                                  setState(() {
                                    streetAddress = updatedAddress['streetAddress'];
                                    city = updatedAddress['city'];
                                    postalCode = updatedAddress['postalCode'];
                                  });

                                  await sharedPreferenceHelper()
                                      .saveUserStreetAddress(streetAddress!);
                                  await sharedPreferenceHelper()
                                      .saveUserCity(city!);
                                  await sharedPreferenceHelper()
                                      .saveUserPostalCode(postalCode!);
                                }
                              },
                              child: Text(
                                "Edit Address",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildProfileInfo(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Material(
        elevation: 3.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(icon, size: 35.0),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppWidget.lightTextFeildStyle()),
                  Text(value, style: AppWidget.semiboldTextFeildStyle()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileActionButton(
      String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Material(
          elevation: 3.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, size: 35.0),
                SizedBox(width: 10.0),
                Text(title, style: AppWidget.semiboldTextFeildStyle()),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
