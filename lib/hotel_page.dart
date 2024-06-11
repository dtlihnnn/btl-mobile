import 'package:flutter/material.dart';
import 'checkout.dart';

class HotelPage extends StatelessWidget {
  final Map<String, dynamic> hotelData;

  HotelPage({required this.hotelData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                hotelData['ImageURL'],
                height: 300,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned(
                top: 50,
                left: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 115, 0, 255),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              constraints: const BoxConstraints(
                  minWidth: double.infinity, maxWidth: double.infinity),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      hotelData['Name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 5),
                        Text(hotelData['Address']),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${hotelData['Price']}/night',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          '4.2/5 (1456 reviews)',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'You will find every comfort because many of the spacious hotel suites hotels offer for travelers and of course the hotel is very comfortable.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.restaurant, size: 24),
                      Icon(Icons.wifi, size: 24),
                      Icon(Icons.currency_exchange, size: 24),
                      Icon(Icons.hotel, size: 24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              hotelData: hotelData,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Select Room',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
