// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid;
  String? name;
  String? lastName;
  String? gender;
  String? birthDate;
  String? phone;
  String? email;
  String? idJefe;
  String? img;
  bool? state;

  User({
    this.name,
    this.lastName,
    this.gender,
    this.birthDate,
    this.phone,
    this.email,
    this.idJefe,
    this.uid,
    this.img,
    this.state,
  });
  static User fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return User(
      name: dataSnapshot['name'],
      lastName: dataSnapshot['lastName'],
      gender: dataSnapshot['gender'],
      birthDate: dataSnapshot['birthDate'],
      phone: dataSnapshot['phone'],
      email: dataSnapshot['email'],
      idJefe: dataSnapshot['idJefe'],
      uid: dataSnapshot['uid'],
      
      img: dataSnapshot['img'],
      state: dataSnapshot['state'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastName': lastName,
        'gender': gender,
        'birthDate': birthDate,
        'phone': phone,
        'email': email,
        'idJefe': idJefe,
        'img': img,
        'state': state,
      };
}
