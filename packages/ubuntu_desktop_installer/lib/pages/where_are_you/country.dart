class Country {
  String? name;
  String? city;

  Country({this.city, this.name});

  factory Country.fromJson(Map<String, dynamic> json) =>
      Country(name: json['country'], city: json['city']);
}
