class Institution {
  // {
  // "_id": "6530479882b58f30260b6534",
  // "name": "University of Waterloo",
  // "province": "Ontario",
  // "city": "Waterloo",
  // "country": "Canada"
  // }
  final String id;
  final String name;
  final String province;
  final String city;
  final String country;

  Institution._(
      {required this.id,
      required this.name,
      required this.province,
      required this.city,
      required this.country});

  factory Institution.fromMap(Map data) {
    return Institution._(
        id: data['_id'],
        name: data['name'],
        province: data['province'],
        city: data['city'],
        country: data['country']);
  }
}
