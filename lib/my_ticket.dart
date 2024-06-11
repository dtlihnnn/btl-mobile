import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'background_item.dart';

class MyTicketsPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> getBookings() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return [];
    }
    String userId = user.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot hotelSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('hotel_bookings')
        .get();

    QuerySnapshot flightSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('flight_bookings')
        .get();

    List<Map<String, dynamic>> bookings = [];

    for (var doc in hotelSnapshot.docs) {
      bookings.add(doc.data() as Map<String, dynamic>);
    }

    for (var doc in flightSnapshot.docs) {
      bookings.add(doc.data() as Map<String, dynamic>);
    }

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace: const BackgroundImages(
            title: "My tickets", content: ""),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          } else {
            List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                var booking = bookings[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (booking.containsKey('hotel_name'))
                          ...[
                            Text(
                              'Hotel Booking',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text("Hotel Name: ${booking['hotel_name']}"),
                            Text("Check-in: ${booking['check_in']}"),
                            Text("Check-out: ${booking['check_out']}"),
                            Text("Total Price: \$${booking['total_price']}"),
                          ]
                        else if (booking.containsKey('origin'))
                          ...[
                            Text(
                              'Flight Booking',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text("From: ${booking['origin']}"),
                            Text("To: ${booking['destination']}"),
                            Text("Departure time: ${booking['departure_time']}"),
                            Text("Total Price: \$${booking['total_price']}"),
                          ],
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
