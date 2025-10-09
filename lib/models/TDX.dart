import 'package:flutter/material.dart';

class Station {
  final String stationUID;
  final String stationID;
  final StationName stationName;
  final String stationAddress;
  final String stationPhone;
  final String operatorID;
  final String stationClass;
  final DateTime updateTime;
  final int versionID;
  final StationPosition stationPosition;
  final String locationCity;
  final String locationCityCode;
  final String locationTown;
  final String locationTownCode;

  Station({
    required this.stationUID,
    required this.stationID,
    required this.stationName,
    required this.stationAddress,
    required this.stationPhone,
    required this.operatorID,
    required this.stationClass,
    required this.updateTime,
    required this.versionID,
    required this.stationPosition,
    required this.locationCity,
    required this.locationCityCode,
    required this.locationTown,
    required this.locationTownCode,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationUID: json['StationUID'] as String,
      stationID: json['StationID'] as String,
      stationName: StationName.fromJson(json['StationName']),
      stationAddress: json['StationAddress'] as String,
      stationPhone: json['StationPhone'] as String,
      operatorID: json['OperatorID'] as String,
      stationClass: json['StationClass'] as String,
      updateTime: DateTime.parse(json['UpdateTime'] as String),
      versionID: json['VersionID'] as int,
      stationPosition: StationPosition.fromJson(json['StationPosition']),
      locationCity: json['LocationCity'] as String,
      locationCityCode: json['LocationCityCode'] as String,
      locationTown: json['LocationTown'] as String,
      locationTownCode: json['LocationTownCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StationUID': stationUID,
      'StationID': stationID,
      'StationName': stationName.toJson(),
      'StationAddress': stationAddress,
      'StationPhone': stationPhone,
      'OperatorID': operatorID,
      'StationClass': stationClass,
      'UpdateTime': updateTime.toIso8601String(),
      'VersionID': versionID,
      'StationPosition': stationPosition.toJson(),
      'LocationCity': locationCity,
      'LocationCityCode': locationCityCode,
      'LocationTown': locationTown,
      'LocationTownCode': locationTownCode,
    };
  }
}

class StationName {
  final String zhTw;
  final String en;

  StationName({required this.zhTw, required this.en});

  factory StationName.fromJson(Map<String, dynamic> json) {
    return StationName(zhTw: json['Zh_tw'] as String, en: json['En'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'Zh_tw': zhTw, 'En': en};
  }

  @override
  String toString() => en;
}

class StationPosition {
  final double positionLon;
  final double positionLat;
  final String geoHash;

  StationPosition({required this.positionLon, required this.positionLat, required this.geoHash});

  factory StationPosition.fromJson(Map<String, dynamic> json) {
    return StationPosition(
      positionLon: (json['PositionLon'] as num).toDouble(),
      positionLat: (json['PositionLat'] as num).toDouble(),
      geoHash: json['GeoHash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'PositionLon': positionLon, 'PositionLat': positionLat, 'GeoHash': geoHash};
  }
}
