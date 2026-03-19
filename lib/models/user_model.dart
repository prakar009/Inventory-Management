class AppUser {
  final String uid;
  final String email;
  final String role;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      role: map['role'] ?? 'viewer',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
    };
  }
}