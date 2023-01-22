import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String profileImg;
  final String banner;
  final bool isAuthenticated;
  final int karma;
  final List<String> awards;
  UserModel({
    required this.uid,
    required this.name,
    required this.profileImg,
    required this.banner,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profileImg,
    String? banner,
    bool? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImg: profileImg ?? this.profileImg,
      banner: banner ?? this.banner,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profileImg': profileImg,
      'banner': banner,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profileImg: map['profileImg'] as String,
      banner: map['banner'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      karma: map['karma'] as int,
      awards: List<String>.from((map['awards'] as List<String>)),
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profileImg: $profileImg, banner: $banner, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.profileImg == profileImg &&
        other.banner == banner &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        profileImg.hashCode ^
        banner.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}
