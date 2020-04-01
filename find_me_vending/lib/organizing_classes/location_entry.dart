class Entry {
  double lat;
  double long;
  int type; // 0 = food vending, 1 = drink vending, 2 = restroom, 3 = water fountain
  String imageUrl;
  String buildingCode;
  String loc;
  String id;

  Entry(this.id, this.type, this.lat, this.long, this.imageUrl, this.buildingCode, this.loc);
}