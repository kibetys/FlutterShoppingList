import 'package:flutter/material.dart';
import 'package:flutter_app/model/shoppingItem.dart';
import 'package:flutter_app/util/dbhelper.dart';

DbHelper helper = DbHelper();

final List<String> actions = const <String>['Save Item', 'Delete Item', 'Back'];

const itemSave = 'Save Item';
const itemDelete = 'Delete Item';
const goBack = 'Back';

class EditShoppingItem extends StatefulWidget {
  final ShoppingItem shoppingItem;
  EditShoppingItem(this.shoppingItem);

  @override
  State<StatefulWidget> createState() => EditShoppingItemState(shoppingItem);
}

class EditShoppingItemState extends State {
  ShoppingItem shoppingItem;
  EditShoppingItemState(this.shoppingItem);
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text = shoppingItem.name;
    amountController.text = shoppingItem.amount.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(shoppingItem.name),
            actions: <Widget>[
              PopupMenuButton<String>(
                  onSelected: select,
                  itemBuilder: (BuildContext context) {
                    return actions.map((String action) {
                      return PopupMenuItem<String>(
                        value: action,
                        child: Text(action),
                      );
                    }).toList();
                  })
            ]),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      style: textStyle,
                      onChanged: (value) => this.updateName(),
                      decoration: InputDecoration(
                          labelText: 'Product',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 35.0),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => this.updateAmount(),
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ))
                  ],
                ),
              ],
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          save();
        },
        tooltip: "Add new ShoppingItem",
        child: new Icon(Icons.add),
      ),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case itemSave:
        save();
        break;
      case itemDelete:
        Navigator.pop(context, true);
        if (shoppingItem.id == null) {
          return;
        }
        result = await helper.deleteShopItem(shoppingItem.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
              title: Text('Delete Item'),
              content: Text('Shopping item has been deleted'));
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case goBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    // if id is not null user is editing an existing item
    // so we want to call update method
    if (shoppingItem.id != null) {
      helper.updateShopItem(shoppingItem);
    } else {
      helper.insertShopItem(shoppingItem);
    }
    Navigator.pop(context, true);
  }

  void updateName() {
    shoppingItem.name = nameController.text;
  }

  void updateAmount() {
    shoppingItem.amount = int.tryParse(amountController.text);
  }
}
