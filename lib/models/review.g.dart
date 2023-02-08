// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Review _$$_ReviewFromJson(Map<String, dynamic> json) => _$_Review(
      createdAt: DateTime.parse(json['createdAt'] as String),
      rating: json['rating'] as int,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ReviewToJson(_$_Review instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'rating': instance.rating,
      'location': instance.location.toJson(),
    };

_$_Location _$$_LocationFromJson(Map<String, dynamic> json) => _$_Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$_LocationToJson(_$_Location instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
