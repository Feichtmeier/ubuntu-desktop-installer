class City {
  String name;
  String country;
  String countryCode;
  String stateCode;
  List<dynamic> timeZone;

  City(
      {required this.name,
      required this.country,
      required this.countryCode,
      required this.stateCode,
      required this.timeZone});

  factory City.fromJson(Map<String, dynamic> json) => City(
      name: json['name'],
      country: json['country'],
      countryCode: json['country_code'],
      stateCode: json['state_code'],
      timeZone: json['time_zone']);
}
