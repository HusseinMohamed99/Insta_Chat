class UserModel {
  final String name;
  final String email;
  final String phone;
  final String uid;
  final String token;
  final String image;
  final String bio;
  final bool? isEmailVerified;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.uid = '',
    this.token = '',
    required this.image,
    required this.bio,
    required this.isEmailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return (UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uid: json['uid'],
      token: json['token'],
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
      'token': token,
      'image': image,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
