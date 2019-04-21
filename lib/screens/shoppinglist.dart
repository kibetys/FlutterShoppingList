import 'package:flutter/material.dart';
import 'package:flutter_app/model/shoppingItem.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:flutter_app/screens/editShoppingItem.dart';

class ShopList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShopListState();
}

final List<String> actions = const <String>['Delete All'];
final List<String> itemActions = const<String>['Delete Item', 'Edit Item'];

const deleteAll = 'Delete All';

class ShopListState extends State {
  DbHelper helper = DbHelper();
  List<ShoppingItem> shopItems;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (shopItems == null) {
      shopItems = List<ShoppingItem>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Shopping List'),
          automaticallyImplyLeading: false,
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
      body: shoppingListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddScreen(ShoppingItem('', 1));
        },
        tooltip: "Add new ShoppingItem",
        child: new Icon(Icons.add),
      ),
    );
  }
  Padding getAmount(int position) {
    if (position == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
        child: Text(
          shopItems[position].amount.toString(),
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 1.0, 1.0, 1.0),
        child: Text(
          shopItems[position].amount.toString(),
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }
  }

  Text getTitle(String title, int position) {
    if (position == 0) {
      return Text(title,
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold));
    } else {
      return Text("",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold));
    }
  }

  ListView shoppingListItems() {
    return ListView.builder(
      itemBuilder: (context, position) {
        return Column(
          children: <Widget>[
            GestureDetector(
                onLongPress: () {
                  showMenu(
                    context: context,
                    items: itemActions.map((String action) {
                    return PopupMenuItem<String>(
                      value: action,
                      child: Text(action),
                    );
                  }).toList()
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 12.0, 12.0, 6.0),
                            child: getTitle("Product", position)),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            shopItems[position].name,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 12.0, 12.0, 6.0),
                              child: getTitle("Amount", position)),
                          getAmount(position)
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                    child: FloatingActionButton(
                        heroTag: "actionBtn-" + position.toString(),
                        onPressed: () {
                          delete(position);
                          },
                      tooltip: "Delete shopping item",
                      child: new Icon(Icons.delete),
                    )
                  )
                  ],
                )),
            Divider(
              height: 2.0,
              color: Colors.grey,
            )
          ],
        );
      },
      itemCount: count,
    );
  }

  void getData() {
    // open database or create it if it doesn't exist
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final shoppingItemsFuture = helper.getShopItems();
      shoppingItemsFuture.then((result) {
        List<ShoppingItem> shopList = List<ShoppingItem>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          shopList.add(ShoppingItem.fromObject(result[i]));
          debugPrint(shopList[i].name);
        }
        setState(() {
          shopItems = shopList;
          count = count;
        });
        debugPrint("items " + count.toString());
      });
    });
  }

  void navigateToAddScreen(ShoppingItem shoppingItem) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditShoppingItem(shoppingItem)),
    );
    if (result == true) {
      getData();
    }
  }

  void delete(position) async {
   int result = await helper.deleteShopItem(shopItems[position].id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
          title: Text('Delete Item'),
          content: Text('Shopping item has been deleted'));
      showDialog(context: context, builder: (_) => alertDialog);
      this.getData();
    }
  }

  void select(String value) async {
    int result;
    switch (value) {
      case deleteAll:
        if (shopItems.length > 0) {
          result = await helper.deleteAll();
        }
        if (result != 0) {
          getData();
          AlertDialog alertDialog = AlertDialog(
              title: Text('Delete'),
              content: Text('All items have been deleted'));
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      default:
        break;
    }
  }
}
