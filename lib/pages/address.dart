import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding

class AddressEditScreen extends StatefulWidget {
  final String? currentAddress;
  final String? currentCity;
  final String? currentPostalCode;

  const AddressEditScreen({
    super.key,
    this.currentAddress,
    this.currentCity,
    this.currentPostalCode,
  });

  @override
  _AddressEditScreenState createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends State<AddressEditScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.currentAddress ?? '';
    _cityController.text = widget.currentCity ?? '';
    _postalCodeController.text = widget.currentPostalCode ?? '';
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use reverse geocoding to get address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Update text fields with retrieved address details
        setState(() {
          _addressController.text = place.street ?? '';
          _cityController.text = place.locality ?? '';
          _postalCodeController.text = place.postalCode ?? '';
        });

        // Show a confirmation dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Location Updated"),
            content: Text(
              "Address: ${place.street}\nCity: ${place.locality}\nPostal Code: ${place.postalCode}",
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error fetching location: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Could not fetch location. Please try again."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Street Address"),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: "City"),
            ),
            TextField(
              controller: _postalCodeController,
              decoration: InputDecoration(labelText: "Postal Code"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'streetAddress': _addressController.text,
                  'city': _cityController.text,
                  'postalCode': _postalCodeController.text,
                });
              },
              child: Text("Save Address"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text("Use Current Location"),
            ),
          ],
        ),
      ),
    );
  }
}
