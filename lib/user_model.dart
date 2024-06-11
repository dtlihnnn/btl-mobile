class UserModel {
  late String? id;
  late String Username;
  late String Email;
  late String Password;
  UserModel({
    this.id,
    required this.Email,
    required this.Username,
    required this.Password,
  });
  toJson() {
    return {
      "Username": Username,
      "Email": Email,
      "Password": Password,
    };
  }
}
