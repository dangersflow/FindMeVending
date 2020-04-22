List<Item> itemsMasterList = [];


class Item {
  String id;
  String name;
  List<String> otherNames;
  bool lowStock;

  Item(this.id, this.name, this.lowStock, {this.otherNames,}) {
    itemsMasterList.add(this);
  }
}