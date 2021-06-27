import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    required this.street,
    required this.city,
    required this.province,
    required this.country,
  });

  final String street;
  final String city;
  final String province;
  final String country;

  @override
  List<Object> get props => <Object>[street, city, province, country];
}
