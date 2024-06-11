import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/hotel_model.dart';
import 'package:btl_mobile/success_booking_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';


class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> hotelData;

  CheckoutScreen({required this.hotelData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 237, 237),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 237, 237),
        toolbarHeight: 180,
        flexibleSpace: const BackgroundImages(title: "Checkout", content: ""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Progress Indicator
              // Room Details
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotelData['Name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(hotelData['Description']),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.bed),
                        SizedBox(width: 5),
                        Text('2 King Bed'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _CheckInOutIcon(
                          icon: Icons.schedule,
                          label: 'Check-in',
                          date: 'Fri, 13 Feb',
                        ),
                        Spacer(),
                        _CheckInOutIcon(
                          icon: Icons.schedule,
                          label: 'Check-out',
                          date: 'Sat, 14 Feb',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Price Breakdown
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PriceItem(label: '1 Night', amount: '\$${hotelData['Price']}'),
                    _PriceItem(label: 'Taxes and Fees', amount: 'Free'),
                    SizedBox(height: 10),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '\$${hotelData['Price']}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Payment Method
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Credit / Debit Card',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/Mastercard-logo.png',
                          height: 24.0,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Master Card',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Handle change payment method
                          },
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Pay Now Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SuccessfulBookingPage(hotelData: hotelData,)),
                      );
                    },
                    child: const Text(
                      'Pay Now',
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

// Reusable widgets

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.purple : Colors.grey[300],
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            color: isActive ? Colors.purple : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _CheckInOutIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String date;

  const _CheckInOutIcon({
    required this.icon,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          date,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}

class _PriceItem extends StatelessWidget {
  final String label;
  final String amount;

  const _PriceItem({
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(amount),
      ],
    );
  }
}
