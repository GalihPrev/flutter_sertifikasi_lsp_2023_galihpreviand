class User {
  int? id;
  String? username;
  String? password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  // Convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
