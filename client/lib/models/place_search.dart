// Autocomplete class
class PlaceSearch {
  final String description; // name of location
  final String placeId; // identifier

  PlaceSearch({required this.description, required this.placeId});

  // Scrapes data from json using string key arguements
  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['description'], placeId: json['place_id']);
  }

  @override
  String toString() {
    return "PlaceSearch: $description, $placeId";
  }
}
