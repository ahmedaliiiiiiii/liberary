class User {
  final String id;
  final String name;
  final String email;
  final DateTime memberSince;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
    this.token,
  });

  String get initials {
    return name
        .split(' ')
        .map((n) => n.isNotEmpty ? n[0] : '')
        .join('')
        .toUpperCase();
  }

  String get firstName => name.split(' ').first;

  // تحويل من JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      memberSince: DateTime.tryParse(json['memberSince'] ?? '') ?? DateTime.now(),
      token: json['token'],
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'memberSince': memberSince.toIso8601String(),
      'token': token,
    };
  }
}