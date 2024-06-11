import 'dart:convert';
import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/checkout_flight.dart';
import 'package:btl_mobile/flights.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingFlight extends StatefulWidget {
  const BookingFlight({Key? key}) : super(key: key);

  @override
  State<BookingFlight> createState() => _BookingFlights();
}

class _BookingFlights extends State<BookingFlight> {
  String? selectedAirport;
  String? _selectedDestination;
  String? _departureTime;
  String? _price;

  Map<String, String?> flightData = {
    'origin': null,
    'destination': null,
    'departure_time': null,
    'price': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace:
            const BackgroundImages(title: "Booking Your Flights", content: ""),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xFFFE9C5E), // Background color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "One Way",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                96, 34, 171, 1), // Background color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "Round Trip",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                96, 34, 171, 1), // Background color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "Multi-City",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 90,
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
                              Icons.flight,
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
                              "From",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                              width: 5,
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
                                  _selectedDestination = null;
                                  _departureTime = null;
                                  _price = null;

                                  flightData['origin'] = selectedOrigin;
                                  flightData['destination'] = null;
                                  flightData['departure_time'] = null;
                                  flightData['price'] = null;
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
                top: 180,
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
                              "To",
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
                                if (selectedAirport == null) return;

                                // Fetch unique destinations based on selected origin
                                final destinations =
                                    await fetchUniqueDestinations(
                                        selectedAirport!);
                                // Display the list of destinations and wait for the user to select one
                                final selectedDestination = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text('Choose Destination'),
                                      children: destinations
                                          .map<Widget>((destination) {
                                        return SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context, destination);
                                          },
                                          child: Text(destination),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );

                                if (selectedDestination != null) {
                                  final flights = await fetchFlights();
                                  final flight = flights.firstWhere(
                                    (flight) =>
                                        flight['origin'] == selectedAirport &&
                                        flight['destination'] ==
                                            selectedDestination,
                                    orElse: () => null,
                                  );

                                  if (flight != null) {
                                    setState(() {
                                      _selectedDestination =
                                          selectedDestination;
                                      _departureTime = flight['departure_time'];
                                      _price = flight['price'];

                                      flightData['destination'] =
                                          _selectedDestination;
                                      flightData['departure_time'] =
                                          flight['departure_time'];
                                      flightData['price'] = flight['price'];
                                    });
                                  }
                                }
                              },
                              child: Text(
                                _selectedDestination ?? "Choose",
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
                top: 270,
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
                              "Departure",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                _departureTime ?? "Select Flight",
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
                top: 360,
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
                              Icons.people,
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
                              "Passengers",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                _price ?? "Select Flight",
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
                top: 450,
                left: 50,
                child: Container(
                  width: 325,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.white60, // Background color
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: const Row(
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
                              Icons.class_,
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
                              "Class",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Economy",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
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
                top: 540,
                left: MediaQuery.of(context).size.width / 2 - 70,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedDestination != null &&
                            selectedAirport != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Checkout_Flight(flightData: flightData),
                            ),
                          );
                        } else {
                          // Show a message to the user to select both destination and airport
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please select both a destination and an airport.'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Select Ticket',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
