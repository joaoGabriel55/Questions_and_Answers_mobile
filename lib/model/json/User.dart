class User {
  final String name;
  final String token;
  final String email;
  final int userId;

  User(this.name, this.token, this.email, this.userId);

  User.fromJson(Map<String, dynamic> json)
      : name = json['user']['nome'],
        token = json['token'],
        email = json['user']['email'],
        userId = json['user']['id'];

  Map<String, dynamic> toJson() => {
        'nome': name,
        'token': token,
        'email': email,
        'id': userId,
      };
}
