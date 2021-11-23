class User{
  String name;
  String city;
  String email;
  User({required this.name,required this.city,required this.email});

  factory User.fromJson(Map<String,dynamic> map){
    return User(
      name: map['name'],
      city:map['city'],
      email:map['email'],
    );
  }

}