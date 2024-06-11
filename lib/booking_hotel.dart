import 'dart:convert';
import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/flights.dart';
import 'package:btl_mobile/hotel_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingHotel extends StatefulWidget {
  const BookingHotel({Key? key}) : super(key: key);

  @override
  State<BookingHotel> createState() => _BookingHotels();
}

class _BookingHotels extends State<BookingHotel> {
  String? _selectedDestination;
  String? selectedAirport;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace:
            const BackgroundImages(title: "Booking Your Hotels", content: ""),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 50,
                child: Container(
                  width: 325,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.white60, // Background color
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 25,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Colors.purple,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          bottom: 5,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Destination",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Fetch unique origins from API
                                final origins = await fetchUniqueOrigins();
                                // Display the list of origins and wait for the user to select one
                                final selectedOrigin = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text('Choose Origin'),
                                      children: origins.map<Widget>((origin) {
                                        return SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context, origin);
                                          },
                                          child: Text(origin),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                                // Update selectedAirport with the selected origin
                                setState(() {
                                  selectedAirport = selectedOrigin;
                                  _selectedDestination = selectedOrigin;
                                });
                              },
                              child: Text(
                                selectedAirport ?? "Choose",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 140,
                left: 50,
                child: Container(
                  width: 325,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.white60, // Background color
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 25,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.purple,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          bottom: 5,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Select Date",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDatePicker();
                              },
                              child: Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                    : 'Select',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 230,
                left: 50,
                child: Container(
                  width: 325,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.white60, // Background color
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 25,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bed,
                              color: Colors.purple,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          bottom: 5,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Guest and Room",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: _showRoomSelectionDialog,
                              child: Text(
                                selectedOption,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 320,
                left: 170,
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToHotelList();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.purple, // Set the background color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Set the border radius of the button
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0, // Set the font size of the button text
                      fontWeight: FontWeight
                          .bold, // Set the font weight of the button text
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchHotels() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('hotels').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  String? selectedCountry;

  void _navigateToHotelList() {
    if (_selectedDestination != null) {
      // Navigate to the HotelListPage and pass the selected country
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HotelListPage(selectedCountry: _selectedDestination!),
        ),
      );
    }
  }

  String selectedOption = '1 Room, 2 Guest';
  void _showRoomSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("1 Room, 2 Guest"),
              onTap: () {
                setState(() {
                  selectedOption = "1 Room, 2 Guest";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("1 Room, 1 Guest"),
              onTap: () {
                setState(() {
                  selectedOption = "1 Room, 1 Guest";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
