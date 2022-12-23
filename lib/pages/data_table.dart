import 'dart:ffi';

import 'package:flutter/material.dart';

class Profiles {
  String? user_id;
  String? password;
  String? name;
  String? phonenumber;
  String? address;
  String? email;

  Profiles(
      {this.user_id,
      this.password,
      this.name,
      this.phonenumber,
      this.address,
      this.email});
}

class UserProfiles {
  String? user_id;
  String? password;
  String? name;


  UserProfiles(
      {this.user_id,
      this.password,
      this.name,
    });
}

class Devices {
  String? user_id;
  String? serial_number;
  String? device_name;

  Devices({this.user_id, this.serial_number, this.device_name});
}

class History {
  String? user_id;
  String? sensor;
  String? status;
  DateTime? datetime;

  History({this.user_id, this.sensor, this.status, this.datetime});
}

class Video {
  String? user_id;
  String? video_path;
  String? file_name;

  Video({
    this.user_id,
    this.video_path,
    this.file_name,
  });
}
