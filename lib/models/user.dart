class User {
  // final String key;
  final String name;
  final String email;
  final String photoUrl;

  User({
    //required this.key,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
