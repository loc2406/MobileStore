class User{
  final int? id;
  final String name;
  final String userName;
  final String password;
  final String? role;

  User({this.id, this.role, required this.name, required this.userName, required this.password});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: int.parse(map['id'].toString()),
        name: map['name'],
        userName: map['username'],
        password: map['password'] ?? '',
        role: map['role']);
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'userName': userName,
      'password': password,
    };
  }
}