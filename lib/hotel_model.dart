class HotelData {
  final String Name;
  final String Description;
  final String Price;
  final String Country;
  final String Address;
  final String ImageURL;
  // Thêm các trường dữ liệu khác tùy theo nhu cầu

  HotelData({
    required this.Name,
    required this.Description,
    required this.Price,
    required this.ImageURL,
    required this.Country,
    required this.Address,
  });

  factory HotelData.fromMap(Map<String, dynamic> data) {
    return HotelData(
      Name: data['Name'] ?? '',
      Description: data['Description'] ?? '',
      Price: data['Price']?.toDouble() ?? '',
      Address: data['Address']?.toDouble() ?? '',
      Country: data['Country']?.toDouble() ?? '',
      ImageURL: data['ImageURL']?.toDouble() ?? '',
    );
  }
}