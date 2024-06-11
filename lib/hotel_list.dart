// Hotel List Page
import 'package:btl_mobile/background_item.dart';
import 'package:btl_mobile/hotel_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelListPage extends StatefulWidget {
  final String selectedCountry;

  HotelListPage({required this.selectedCountry});

  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  List<Map<String, dynamic>> hotels = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  void _fetchHotels() {
    // Fetch hotels from Firestore based on the selected country
    FirebaseFirestore.instance
        .collection('hotels')
        .where('Country', isEqualTo: widget.selectedCountry)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        hotels = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                title: 'Hotels in ${widget.selectedCountry}',
                content: "",
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> hotel = hotels[index];
          return HotelCard(hotel: hotel);
        },
      ),
    );
  }

  Widget HotelCard({required Map<String, dynamic> hotel}) {
    return Container(
      width: 400, // Set a fixed width
      height: 400, // Set a fixed height
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(hotel['ImageURL']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelPage(hotelData: hotel,),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hotel['Name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
