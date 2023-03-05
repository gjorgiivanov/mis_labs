class Location {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});

  bool equals(Location locationToCompare) {
    if (latitude == locationToCompare.latitude &&
        longitude == locationToCompare.longitude) {
      return true;
    }
    return false;
  }
}
