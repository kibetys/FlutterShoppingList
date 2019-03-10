class ShoppingItem {
  int _id;
  String _name;

  // ShoppingItem constructor before item has been created
  ShoppingItem (this._name);
  // ShoppingItem constructor when created item is being edited
  ShoppingItem.withId(this._id, this._name);
  int get id => _id;
  String get name => _name;

  set name (String newName){
    if (newName.length <= 255) {
      _name = newName;
    }
  }

  Map <String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    if (_id !=null) {
      map["id"] = _id; 
    }
    return map;
  }

  ShoppingItem.fromObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
  }
}