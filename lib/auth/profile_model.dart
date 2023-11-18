import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  ProfileModel({
    this.id,
    this.createdAt,
    this.handle,
    this.firstName,
    this.lastName,
    this.bio
  });

  String? id;
  DateTime? createdAt;
  String? handle;
  String? firstName;
  String? lastName;
  String? bio;

  void set(Map<String, dynamic> profileJson) {
    id = profileJson["id"];
    createdAt = profileJson["created_at"] == null ? null : DateTime.parse(profileJson["created_at"]);
    handle = profileJson["handle"];
    firstName = profileJson["first_name"];
    lastName = profileJson["last_name"];
    bio = profileJson["bio"];
    notifyListeners();
  }

  void clear() {
    id = null;
    createdAt = null;
    handle = null;
    firstName = null;
    lastName = null;
    bio = null;
    notifyListeners();
  }
}