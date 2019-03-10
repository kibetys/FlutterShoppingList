class ShoppingItem {
  int _id;
  String _name;
  int _amount;

  // ShoppingItem constructor before item has been created
  ShoppingItem (this._name, this._amount);
  // ShoppingItem constructor when created item is being edited
  ShoppingItem.withId(this._id, this._name, this._amount);
  int get id => _id;
  String get name => _name;
  int get amount => _amount;

  set name (String newName){
    if (newName.length <= 255) {
      _name = newName;
    }
  }

  set amount (int newAmount) {
    if (newAmount > 0) {
      _amount =newAmount;
    }
  }

  Map <String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["amount"] =_amount;

    if (_id !=null) {
      map["id"] = _id; 
    }
    return map;
  }

  ShoppingItem.fromObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
    this._amount = o["amount"];
  }
}