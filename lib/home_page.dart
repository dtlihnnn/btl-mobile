import 'dart:math';
import 'package:btl_mobile/booking_flight.dart';
import 'package:btl_mobile/booking_hotel.dart';
import 'package:btl_mobile/flights.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:btl_mobile/account_page.dart';

List<Map<String, String>> hotelList = [
  {
    "name": "La Siesta Classic Ma May",
    "imageURL":
        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1c/59/4c/d3/hanoi-la-siesta-hotel.jpg?w=1200&h=-1&s=1",
  },
  {
    "name": "La Sinfonía del Rey",
    "imageURL":
        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1a/65/35/d1/terraco-sky-bar.jpg?w=1200&h=-1&s=1",
  },
  {
    "name": "Muong Thanh Luxury ",
    "imageURL":
        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/87/fc/50/muong-thanh-luxury-da.jpg?w=1200&h=-1&s=1",
  },
  // Thêm các mục khác nếu cần
];

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  _TrangChu createState() => _TrangChu();
}

class _TrangChu extends State<TrangChu> {
  late String _username = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<List<Map<String, dynamic>>> fetchCountries() async {
    final response = await http.get(
        Uri.parse('https://665d70e6e88051d604069591.mockapi.io/countries'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> countryList = [];

      for (var country in data) {
        String name = country['CountryName'];
        String imageUrl = country['ImageUrl'];
        countryList.add({"name": name, "image": imageUrl});
      }

      return countryList;
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _username = userData['username'];
        });
      } else {
        print('Username not found in Firestore.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 1.7,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                        ),
                        color: Colors.blue, // Change the color as needed
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hi, $_username',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Bạn muốn đi đâu?',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications),
                                  color: Colors.white,
                                  onPressed: () {
                                    // Handle notification icon press
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      40.0), // Set the desired border radius
                                  child: Image.asset(
                                    'assets/images/default-avatar.jpg',
                                    width: 70,
                                    height: 70,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            80), // Adjust as needed for spacing below the search box
                    // Add other widgets here if needed
                  ],
                ),
              ),
              Positioned(
                top:
                    170, // Điều chỉnh giá trị này để điều chỉnh vị trí dọc của ô tìm kiếm
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.black,
                        onPressed: () {
                          showSearch(context: context, delegate: DataSearch());
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onTap: () {
                      showSearch(context: context, delegate: DataSearch());
                    },
                  ),
                ),
              ),
              Positioned(
                top:
                    250, // Điều chỉnh giá trị này để điều chỉnh vị trí dọc của ba ô vuông
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingHotel()),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(
                                  0xFFFE9C5E), // Background color of the square 1
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Icon(Icons.hotel),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Hotel',
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 13, // Text size
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingFlight()),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(
                                  0xFFFE9C5E), // Background color of the square 1
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Icon(Icons.flight),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Flight',
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 13, // Text size
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                62, 200, 188, 1), // Màu nền của ô vuông 1
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.flight),
                                Icon(Icons.hotel)
                              ]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'All',
                          style: TextStyle(
                            color: Colors.black, // Màu văn bản
                            fontSize: 13, // Kích thước văn bản
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 380,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Destination",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 390, // Điều chỉnh vị trí dọc của ListView
                left: 20,
                right: 20,
                bottom:
                    20, // Đảm bảo ListView chiếm toàn bộ không gian dọc còn lại
                child: FutureBuilder(
                  future: fetchCountries(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>>? countryList = snapshot.data;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Xử lý khi người dùng nhấn vào một quốc gia
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    countryList![index]["image"],
                                    width: 180,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      countryList[index]["name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const Positioned(
                top: 840,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Hotel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 850, // Điều chỉnh vị trí dọc của ListView
                left: 20,
                right: 20,
                bottom:
                    20, // Đảm bảo ListView chiếm toàn bộ không gian dọc còn lại
                child: FutureBuilder(
                  future: Future.value(
                      hotelList), // Sử dụng Future.value để truyền trực tiếp hotelList
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<
                          Map<String,
                              dynamic>> hotelList = snapshot.data as List<
                          Map<String,
                              dynamic>>; // Ép kiểu dữ liệu của snapshot.data
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: hotelList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Xử lý khi người dùng nhấn vào một khách sạn
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    hotelList[index]["imageURL"],
                                    width: 180,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      hotelList[index]["name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor:
                                            const Color.fromARGB(59, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<String> allData = [
    'Viet Nam',
    'My',
    'Brazil',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Danh sách gợi ý tìm kiếm dựa trên từ khóa nhập vào
    List<String> matchQuery = allData
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            // Xử lý khi người dùng chọn một gợi ý
            // Ví dụ: chuyển đến trang chi tiết hoặc thực hiện hành động tương ứng
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Trả về một container trống
  }
}
