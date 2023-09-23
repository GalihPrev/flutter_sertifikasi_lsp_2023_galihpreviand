class User {
  int? id;
  String? username;
  String? password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'username': username,
      'password': password,
    };

    return map;
  }
}
