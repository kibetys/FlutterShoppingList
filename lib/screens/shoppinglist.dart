import 'package:flutter/material.dart';
import 'package:flutter_app/model/shoppingItem.dart';
import 'package:flutter_app/util/dbhelper.dart';

class ShopList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShopListState();

}

class ShopListState extends State {
  DbHelper helper =DbHelper();
  List<ShoppingItem> shopitems;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (shopitems == null) {
      shopitems = List<ShoppingItem>();
      getData();
    }
    return Scaffold(
      body: shoppingListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: "Add new ShoppingItem",
        child: new Icon(Icons.add),
      ),
    );
  }

  Padding getAmount(int position) {
    if (position == 0) {
      return Padding(
        padding:
            const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
        child: Text(
          shopitems[position].amount.toString(),
          style: TextStyle(fontSize: 18.0),
        ),
      );
    } else {
      return Padding(
        padding:
            const EdgeInsets.fromLTRB(10.0, 1.0, 45.0, 1.0),
        child: Text(
          shopitems[position].amount.toString(),
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }

  }

  Text getTitle(String title, int position) {
    if (position == 0) {
      return  Text(title, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold));
    } else {
      return  Text("", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold));
    }
  }

    ListView shoppingListItems() {
    return ListView.builder(
      itemBuilder: (context, position) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                      child: getTitle("Product", position)
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                      child: Text(
                        shopitems[position].name,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                        const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                      child: getTitle("Amount", position)
                    ),
                    getAmount(position)
                    ],
                  ),
                ),
              ],
            ),
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
        shoppingItemsFuture.then((result){
          List<ShoppingItem> shopList = List<ShoppingItem>();
          count = result.length;
          for (int i=0; i<count; i++) {
            shopList.add(ShoppingItem.fromObject(result[i]));
            debugPrint(shopList[i].name);
          }
          setState(() {
              shopitems = shopList;
              count = count;
          });
          debugPrint("items " + count.toString());
        });
    });
  }
}