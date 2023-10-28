class UserModel {
  final String name;
  final String email;
  final String phone;
  final String uid;
  final String image;
  final String bio;
  final bool isEmailVerified;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.uid = '',
    required this.image,
    required this.bio,
    this.isEmailVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return (UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uid: json['uid'],
      image: json['image'],
      bio: json['bio'],
      isEmailVerified: json['isEmailVerified'],
    ));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'image': image,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
