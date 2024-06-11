import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/bottom_bar_layout.dart';
import 'package:btl_mobile/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SuccessfulBookingPage extends StatelessWidget {
  final Map<String, dynamic> hotelData;
  Future<void> saveBookingToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }
    String userId = user.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference bookings = firestore.collection('users')
        .doc(userId)
        .collection('hotel_bookings');

    Map<String, dynamic> bookingData = {
      'hotel_name': hotelData['Name'],
      'check_in': checkInDate,
      'check_out': checkOutDate,
      'total_price': hotelData['Price'],
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await bookings.add(bookingData);
      print('Booking added to Firestore');
    } catch (e) {
      print('Error adding booking: $e');
    }
  }
  SuccessfulBookingPage({required this.hotelData});
  String checkOutDate = 'Fri, 13 Fed';
  String checkInDate = 'Fri, 14 Fed';
  @override
  Widget build(BuildContext context) {
    saveBookingToFirestore();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: BackgroundImages(
                title: 'Booking Successful',
                content: "",
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Your Booking is Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Booking Details:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Center(
               child:  Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hotel Name: ${hotelData['Name']}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check-in: ${checkInDate}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check-out: ${checkOutDate}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Total Price: \$${hotelData['Price']}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomBarLayout()),
                      );
                    },
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessfulBookingFlightPage extends StatelessWidget {
  final Map<String, dynamic> flightData;

  SuccessfulBookingFlightPage({required this.flightData});
  String checkOutDate = 'Fri, 13 Fed';
  String checkInDate = 'Fri, 14 Fed';

  Future<void> saveBookingToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }
    String userId = user.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference bookings = firestore.collection('users')
        .doc(userId)
        .collection('flight_bookings');

    Map<String, dynamic> bookingData = {
      'origin': flightData['origin'],
      'destination': flightData['destination'],
      'departure_time': flightData['departure_time'],
      'total_price': flightData['price'],
      'timestamp': FieldValue.serverTimestamp(),
      'user_id': userId,
    };

    try {
      await bookings.add(bookingData);
      print('Booking added to Firestore');
    } catch (e) {
      print('Error adding booking: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    saveBookingToFirestore();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: BackgroundImages(
                title: 'Booking Successful',
                content: "",
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Your Booking is Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Booking Details:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From: ${flightData['origin']}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'To: ${flightData['destination']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Departure time: ${flightData['departure_time']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Total Price: \$${flightData['price']}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomBarLayout()),
                      );
                    },
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
