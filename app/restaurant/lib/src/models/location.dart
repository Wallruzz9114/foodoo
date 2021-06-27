import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({required this.longitude, required this.latitude});

  final double longitude;
  final double latitude;

  @override
  List<Object> get props => <Object>[longitude, latitude];
}
