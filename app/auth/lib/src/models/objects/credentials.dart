class Credentials {
  Credentials({
    this.username,
    this.email,
    required this.password,
  });

  String? username;
  String? email;
  final String password;
}
