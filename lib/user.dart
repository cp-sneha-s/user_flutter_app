import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';



@JsonSerializable()
class User{
  String name;
  String city;
  String email;
  User({required this.name,required this.city,required this.email});

  factory User.fromJson(Map<String,dynamic> data)=>_$UserFromJson(data);

  Map<String,dynamic> toJson()=>_$UserToJson(this);
}