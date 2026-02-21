class User {
  final String id;
  final String name;
  final String email;
  final DateTime memberSince;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
  });

  String get initials {
    return name
        .split(' ')
        .map((n) => n.isNotEmpty ? n[0] : '')
        .join('')
        .toUpperCase();
  }

  String get firstName => name.split(' ').first;
}
