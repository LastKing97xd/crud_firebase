class PeopleResponse {

  final String? id;
  final String name;
  final String? url;

  PeopleResponse({this.id, required this.name, this.url});

  // Convierte un documento de Firebase a PeopleResponse
  factory PeopleResponse.fromJson(Map<String, dynamic> json) => PeopleResponse(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  
  // Convierte un PeopleResponse a un Map (por ejemplo, para subirlo a Firebase)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
